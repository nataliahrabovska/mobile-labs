import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qr_scanner_cubit.dart';
import 'qr_scanner_view.dart';
import '../../../usb/usb_manager.dart';
import '../../../usb/usb_service.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrScannerCubit(UsbManager(UsbService())),
      child: const QrScannerView(),
    );
  }
}
