import 'package:flutter/material.dart';
import 'package:test_lab2/models/sensor_data.dart';
import 'home_app_bar.dart';
import 'home_stats_row.dart';
import 'home_data_list.dart';
import 'home_action_buttons.dart';

class HomeBody extends StatelessWidget {
  final List<SensorData> dataList;

  const HomeBody({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeAppBar(),
        HomeStatsRow(dataList: dataList),
        Expanded(
          child: HomeDataList(dataList: dataList),
        ),
        const HomeActionButtons(),
      ],
    );
  }
}
