import 'package:flutter/material.dart';
import 'package:test_lab2/models/sensor_data.dart';

import 'home_dialogs.dart';

class HomeDataList extends StatelessWidget {
  final List<SensorData> dataList;

  const HomeDataList({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFCF6),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return ListTile(
            title: Text(item.location, style: const TextStyle(color: Color(0xFF292828))),
            subtitle: Text(
              'Temp: ${item.temperature}, Humidity: ${item.humidity}',
              style: const TextStyle(color: Color(0xFF292828)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF292828)),
                  onPressed: () => HomeDialogs.showEditDialog(context, item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF292828)),
                  onPressed: () => HomeDialogs.showDeleteDialog(context, item),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
