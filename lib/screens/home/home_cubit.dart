import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/sensor_data.dart';
import '../../../services/mqtt_service.dart';
import '../../../services/local_storage.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MqttService mqttService;
  final LocalStorageService storageService;

  HomeCubit({
    required this.mqttService,
    required this.storageService,
  }) : super(HomeInitial()) {
    mqttService.onDataReceived = _handleIncomingData;
    loadData();
    _connectToMqtt();
  }

  Future<void> _connectToMqtt() async {
    try {
      await mqttService.connect();
      print(mqttService.isConnected ? '✅ MQTT Connected' : '❌ MQTT not connected');
    } catch (e) {
      emit(HomeError('MQTT connection failed: $e'));
    }
  }

  Future<void> loadData() async {
    emit(HomeLoading());
    try {
      final data = await storageService.loadData();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError('Failed to load data'));
    }
  }

  void _handleIncomingData(SensorData newData) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      bool exists = currentState.dataList.any((d) =>
      d.timestamp == newData.timestamp && d.location == newData.location);

      if (!exists) {
        final updatedList = List<SensorData>.from(currentState.dataList)..add(newData);
        await storageService.addNewData(newData);
        emit(HomeLoaded(updatedList));
      }
    }
  }

  Future<void> addData(SensorData data) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedList = List<SensorData>.from(currentState.dataList)..add(data);
      await storageService.addNewData(data);
      emit(HomeLoaded(updatedList));
    }
  }

  Future<void> deleteData(SensorData data) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedList = List<SensorData>.from(currentState.dataList)..remove(data);
      await storageService.deleteData(data);
      emit(HomeLoaded(updatedList));
    }
  }

  Future<void> editData(SensorData oldData, SensorData updatedData) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedList = List<SensorData>.from(currentState.dataList)
        ..remove(oldData)
        ..add(updatedData);
      await storageService.deleteData(oldData);
      await storageService.addNewData(updatedData);
      emit(HomeLoaded(updatedList));
    }
  }

  @override
  Future<void> close() {
    mqttService.disconnect();
    return super.close();
  }
}
