import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/usb_serial.dart';
import '../../../usb/usb_manager.dart';
import 'qr_scanner_state.dart';

class QrScannerCubit extends Cubit<QrScannerState> {
  final UsbManager usbManager;
  UsbPort? port;

  QrScannerCubit(this.usbManager) : super(const QrScannerInitial()) {
    _initUsb();
  }

  Future<void> _initUsb() async {
    emit(const QrScannerLogUpdated('🔌 Search ESP...'));

    final devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      emit(const QrScannerLogUpdated('❌ ESP not found (no USB)'));
      return;
    }

    await usbManager.dispose();
    port = await usbManager.selectDevice();

    emit(QrScannerLogUpdated(
      port == null ? '❌ Failed to open ESP port' : '✅ ESP connected via USB',
    ));
  }

  Future<void> sendToArduino(String text) async {
    if (port == null) {
      emit(const QrScannerLogUpdated('❌ Port not open'));
      return;
    }

    final String command = 'SAVE:$text\n';
    await usbManager.sendData(command);

    emit(QrScannerLogUpdated('📤 Sent: $text, waiting for an answer...'));
    final response = await _waitForArduinoResponse(port!);

    emit(QrScannerLogUpdated(
      response.trim() == 'SAVED'
          ? '📬 Message saved: $text'
          : '📬 Respond: $response',
    ));
  }

  Future<String> _waitForArduinoResponse(UsbPort port,
      {Duration timeout = const Duration(seconds: 3)}) async {
    final completer = Completer<String>();
    String buffer = '';
    late StreamSubscription<Uint8List> sub;

    sub = port.inputStream!.listen((event) {
      final chunk = String.fromCharCodes(event);
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

  @override
  Future<void> close() {
    usbManager.dispose();
    return super.close();
  }
}
