import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/usb_serial.dart';
import '../../../usb/usb_manager.dart';
import 'saved_qr_state.dart';

class SavedQrCubit extends Cubit<SavedQrState> {
  final UsbManager usbManager;

  SavedQrCubit(this.usbManager) : super(SavedQrLoading()) {
    readMessage();
  }

  Future<void> readMessage() async {
    emit(SavedQrLoading());

    await usbManager.dispose();
    final port = await usbManager.selectDevice();

    if (port == null) {
      emit(const SavedQrError('❌ ESP not found'));
      return;
    }

    await port.inputStream?.listen((event) {
      final cleaned = String.fromCharCodes(event);
      print('🧹 Cleaning before READ: $cleaned');
    }).cancel();

    await Future.delayed(const Duration(milliseconds: 300));

    await usbManager.sendData('READ\n');
    final response = await _readFromArduino(port);

    if (response.startsWith('❌') || response.startsWith('⏱')) {
      emit(SavedQrError(response));
    } else {
      emit(SavedQrLoaded('🔁 Restore: $response'));
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
}
