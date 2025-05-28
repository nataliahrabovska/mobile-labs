import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_lab2/usb/usb_manager.dart';
import 'package:test_lab2/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

class SavedQrScreen extends StatefulWidget {
  const SavedQrScreen({super.key});

  @override
  State<SavedQrScreen> createState() => _SavedQrScreenState();
}

class _SavedQrScreenState extends State<SavedQrScreen> {
  final UsbManager usbManager = UsbManager(UsbService());
  String savedMessage = 'Read...';

  @override
  void initState() {
    super.initState();
    _readMessageFromArduino();
  }

  Future<void> _readMessageFromArduino() async {
    setState(() => savedMessage = 'Read...');

    await usbManager.dispose();
    final port = await usbManager.selectDevice();

    if (port == null) {
      setState(() => savedMessage = '❌ ESP not found');
      return;
    }

    await port.inputStream?.listen((event) {
      final cleaned = String.fromCharCodes(event);
      print('🧹 Cleaning before READ: $cleaned');
    }).cancel();

    await Future.delayed(const Duration(milliseconds: 300));

    print('📤 Sending READ');
    await usbManager.sendData('READ\n');

    final response = await _readFromArduino(port);
    print('📬 Received: $response');

    if (mounted) {
      setState(() {
        savedMessage = response.startsWith("❌") || response.startsWith("⏱")
            ? response
            : "🔁 Restore: $response";
      });
    }
  }

  Future<String> _readFromArduino(UsbPort port) async {
    final completer = Completer<String>();
    String buffer = '';

    StreamSubscription<Uint8List>? sub;
    sub = port.inputStream?.listen(
          (data) {
        final chunk = String.fromCharCodes(data);
        print('📩 RAW: $chunk');
        buffer += chunk;
        if (buffer.contains('\n')) {
          sub?.cancel();
          completer.complete(buffer.trim());
        }
      },
      onError: (error) {
        sub?.cancel();
        completer.completeError('❌ Reading error: $error');
      },
      cancelOnError: true,
    );

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub?.cancel();
        return '⏱ No response from ESP';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved message')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            savedMessage,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
