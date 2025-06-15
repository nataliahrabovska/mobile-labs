import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_lab2/usb/usb_manager.dart';
import 'package:test_lab2/usb/usb_service.dart';

import 'saved_qr_cubit.dart';
import 'saved_qr_state.dart';

class SavedQrScreen extends StatelessWidget {
  const SavedQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedQrCubit(UsbManager(UsbService())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved message')),
        body: BlocBuilder<SavedQrCubit, SavedQrState>(
          builder: (context, state) {
            if (state is SavedQrLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavedQrLoaded) {
              return _buildMessage(state.message);
            } else if (state is SavedQrError) {
              return _buildMessage(state.error);
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
