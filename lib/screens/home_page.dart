import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_lab2/services/mqtt_service.dart';
import 'package:test_lab2/models/sensor_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MqttService _mqttService = MqttService();
  SensorData? _sensorData;

  @override
  void initState() {
    super.initState();
    _mqttService.onDataReceived = _onDataReceived;
    _connectToMqtt();
  }

  void _connectToMqtt() async {
    try {
      print('Connecting to MQTT...');
      await _mqttService.connect(); // Підключення до MQTT
      if (_mqttService.isConnected) {
        print('MQTT Connected');
      } else {
        print('MQTT connection failed');
      }
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDataReceived(SensorData data) {
    setState(() {
      _sensorData = data;
    });
    print('Data received: ${data.toJson()}');  // Лог для перевірки отриманих даних
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      body: Center(
        child: _sensorData == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sensor Data:', style: TextStyle(fontSize: 24)),
            Text('Temperature: ${_sensorData!.temperature} °C', style: TextStyle(fontSize: 18)),
            Text('Humidity: ${_sensorData!.humidity} %', style: TextStyle(fontSize: 18)),
            Text('Date: ${_sensorData!.date}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
