import 'package:flutter/material.dart';
import 'package:test_lab2/models/sensor_data.dart';
import 'package:test_lab2/widgets/info_card.dart';


class HomeStatsRow extends StatelessWidget {
  final List<SensorData> dataList;

  const HomeStatsRow({super.key, required this.dataList});

  double getAverage(List<SensorData> data, double Function(SensorData) selector) {
    if (data.isEmpty) return 0.0;
    final total = data.map(selector).reduce((a, b) => a + b);
    return total / data.length;
  }

  @override
  Widget build(BuildContext context) {
    final avgTemp = getAverage(dataList, (d) => d.temperature);
    final avgHumidity = getAverage(dataList, (d) => d.humidity);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoCard(title: 'Avg Temp', value: '${avgTemp.toStringAsFixed(1)}°C'),
          InfoCard(title: 'Avg Humidity', value: '${avgHumidity.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
