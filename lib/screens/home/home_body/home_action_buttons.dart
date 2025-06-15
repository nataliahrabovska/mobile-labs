import 'package:flutter/material.dart';
import 'home_dialogs.dart';

class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => HomeDialogs.showAddDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFBD59),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Add New Data', style: TextStyle(color: Color(0xFF292828))),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/qr'),
            icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF292828)),
            label: const Text('Scanner QR', style: TextStyle(color: Color(0xFF292828))),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE7E7E7),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/saved'),
            icon: const Icon(Icons.save, color: Color(0xFF292828)),
            label: const Text('View message', style: TextStyle(color: Color(0xFF292828))),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE7E7E7),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
