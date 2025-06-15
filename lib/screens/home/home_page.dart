import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_lab2/screens/home/home_cubit.dart';

import '../../services/mqtt_service.dart';
import '../../services/local_storage.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        mqttService: MqttService(),
        storageService: LocalStorageService(),
      ),
      child: const Scaffold(
        backgroundColor: Color(0xFFFFFCF6),
        body: HomeView(),
      ),
    );
  }
}
