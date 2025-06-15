import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_scanner_cubit.dart';
import 'qr_scanner_state.dart';

class QrScannerView extends StatelessWidget {
  const QrScannerView({super.key});

  void _onQrDetected(BuildContext context, String code) {
    context.read<QrScannerCubit>().sendToArduino(code);
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
                  _onQrDetected(context, code);
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<QrScannerCubit, QrScannerState>(
                  builder: (context, state) {
                    final log = state is QrScannerLogUpdated
                        ? state.log
                        : (state is QrScannerInitial ? state.log : '');
                    return Text(log, style: const TextStyle(fontSize: 16));
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context
                      .read<QrScannerCubit>()
                      .sendToArduino('Тест з Flutter'),
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
