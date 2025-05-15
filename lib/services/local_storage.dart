import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_data.dart';

class LocalStorageService {
  static const String key = 'sensor_data';

  Future<void> saveData(List<SensorData> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonData);
  }

  Future<List<SensorData>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => SensorData.fromJson(e)).toList();
  }

  Future<void> addNewData(SensorData newData) async {
    final data = await loadData();
    data.add(newData);
    await saveData(data);
  }

  Future<void> deleteData(SensorData toDelete) async {
    final data = await loadData();
    data.removeWhere((item) =>
    item.location == toDelete.location &&
        item.temperature == toDelete.temperature &&
        item.humidity == toDelete.humidity &&
        item.date == toDelete.date);
    await saveData(data);
  }

  Future<void> updateData(SensorData oldData, SensorData newData) async {
    final data = await loadData();
    final index = data.indexWhere((item) =>
    item.location == oldData.location &&
        item.temperature == oldData.temperature &&
        item.humidity == oldData.humidity &&
        item.date == oldData.date);
    if (index != -1) {
      data[index] = newData;
      await saveData(data);
    }
  }
}