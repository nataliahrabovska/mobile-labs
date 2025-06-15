import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_lab2/models/sensor_data.dart';
import 'package:test_lab2/screens/home/home_cubit.dart';


class HomeDialogs {
  static void showAddDialog(BuildContext context) {
    final locationController = TextEditingController();
    final tempController = TextEditingController();
    final humidityController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => _buildDialog(
        context,
        title: 'Add New Sensor Data',
        onConfirm: () {
          final newData = SensorData(
            location: locationController.text,
            temperature: double.tryParse(tempController.text) ?? 0.0,
            humidity: double.tryParse(humidityController.text) ?? 0.0,
            timestamp: dateController.text,
          );
          context.read<HomeCubit>().addData(newData);
          Navigator.pop(context);
        },
        controllers: [locationController, tempController, humidityController, dateController],
      ),
    );
  }

  static void showEditDialog(BuildContext context, SensorData oldData) {
    final locationController = TextEditingController(text: oldData.location);
    final tempController = TextEditingController(text: oldData.temperature.toString());
    final humidityController = TextEditingController(text: oldData.humidity.toString());
    final dateController = TextEditingController(text: oldData.timestamp);

    showDialog(
      context: context,
      builder: (_) => _buildDialog(
        context,
        title: 'Edit Sensor Data',
        onConfirm: () {
          final updated = SensorData(
            location: locationController.text,
            temperature: double.tryParse(tempController.text) ?? 0.0,
            humidity: double.tryParse(humidityController.text) ?? 0.0,
            timestamp: dateController.text,
          );
          context.read<HomeCubit>().editData(oldData, updated);
          Navigator.pop(context);
        },
        controllers: [locationController, tempController, humidityController, dateController],
      ),
    );
  }

  static void showDeleteDialog(BuildContext context, SensorData item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFCF6),
        title: const Text('Delete Sensor Data'),
        content: const Text('Are you sure you want to delete this data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF292828))),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().deleteData(item);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFBD59)),
            child: const Text('Delete', style: TextStyle(color: Color(0xFF292828))),
          ),
        ],
      ),
    );
  }

  static Widget _buildDialog(
      BuildContext context, {
        required String title,
        required VoidCallback onConfirm,
        required List<TextEditingController> controllers,
      }) {
    final labels = ['Location', 'Temperature', 'Humidity', 'Date (DD/MM/YYYY HH:mm:ss)'];

    return AlertDialog(
      backgroundColor: const Color(0xFFFFFCF6),
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: List.generate(
            controllers.length,
                (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: controllers[i],
                decoration: InputDecoration(
                  hintText: labels[i],
                  hintStyle: const TextStyle(color: Color(0xFF292828)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF292828))),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFBD59)),
          child: const Text('Save', style: TextStyle(color: Color(0xFF292828))),
        ),
      ],
    );
  }
}
