import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:test_lab2/usb/usb_manager.dart';
import 'package:test_lab2/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final UsbManager usbManager = UsbManager(UsbService());
  UsbPort? port;
  String debugLog = '🟢 Ready for the test';

  @override
  void initState() {
    super.initState();
    _initUsb();
  }

  Future<void> _initUsb() async {
    setState(() => debugLog = '🔌 Search ESP...');

    final devices = await UsbSerial.listDevices();
    print('🔌 USB devices found: ${devices.length}');

    if (devices.isEmpty) {
      setState(() => debugLog = '❌ ESP not found (no USB)');
      return;
    }

    for (var d in devices) {
      print('🔍 Device: ${d.productName}, VID: ${d.vid}, PID: ${d.pid}');
    }

    await usbManager.dispose();
    port = await usbManager.selectDevice();

    if (port == null) {
      setState(() => debugLog = '❌ Failed to open ESP port');
    } else {
      setState(() => debugLog = '✅ ESP connected via USB');
    }
  }

  Future<String> _waitForArduinoResponse(UsbPort port,
      {Duration timeout = const Duration(seconds: 3)}) async {
    final completer = Completer<String>();
    String buffer = '';
    late StreamSubscription<Uint8List> sub;

    sub = port.inputStream!.listen((event) {
      final chunk = String.fromCharCodes(event);
      print('📩 RAW: $chunk');
      buffer += chunk;
      if (buffer.contains('\n')) {
        sub.cancel();
        completer.complete(buffer.trim());
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      sub.cancel();
      return '⏱ Arduino did not respond';
    });
  }

  Future<void> _sendToArduino(String text) async {
    if (port == null) {
      setState(() => debugLog = '❌ Port not open');
      return;
    }

    final String command = 'SAVE:$text\n';
    print('📤 Sending: $command');

    await usbManager.sendData(command);

    setState(() => debugLog = '📤 Sent: $text, waiting for an answer...');
    final response = await _waitForArduinoResponse(port!);

    print('📬 Received: $response');

    setState(() {
      debugLog = (response.trim() == 'SAVED')
          ? '📬 Message saved: $text'
          : '📬 Respond: $response';
    });
  }

  void _onQrDetected(String code) {
    print('🧪 Scanned QR: $code');
    _sendToArduino(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR code scanning')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final code = barcode.rawValue;
                if (code != null) {
                  _onQrDetected(code);
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(debugLog, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _sendToArduino('Тест з Flutter'),
                  child: const Text('📤 Submit "Test with Flutter" manually'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('⬅️ Back'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
