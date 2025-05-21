import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/sensor_data.dart';

class MqttService {
  final _client = MqttServerClient('test.mosquitto.org', 'grainDocClient')
    ..port = 1883
    ..logging(on: true)
    ..keepAlivePeriod = 60;

  Function(SensorData)? onDataReceived;
  Function()? onDisconnected;
  Function()? onConnected;
  bool _isConnected = false;

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> connect() async {
    if (!await _checkInternetConnection()) {
      print('No internet connection. Cannot connect to MQTT.');
      return;
    }

    try {
      _client.onConnected = _handleConnected;
      _client.onDisconnected = _handleDisconnected;
      _client.onSubscribed = _onSubscribed;

      final connMess = MqttConnectMessage()
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      _client.connectionMessage = connMess;

      await _client.connect();

      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT connected successfully');

        _client.subscribe('grainDoc/sensor', MqttQos.atLeastOnce);

        _client.updates?.listen(
              (List<MqttReceivedMessage<MqttMessage>> messages) {
            if (!_isConnected) {
              print('MQTT client is disconnected, ignoring messages.');
              return;
            }
            final recMess = messages[0].payload as MqttPublishMessage;
            final payloadString =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
            print('Received message (raw): $payloadString');
            try {
              final jsonData = jsonDecode(payloadString);
              if (jsonData is Map<String, dynamic>) {
                final data = SensorData.fromJson(jsonData);
                onDataReceived?.call(data);
              }
            } catch (e) {
              print('JSON decode error: $e');
            }
          },
          onError: (error) => print('MQTT stream error: $error'),
          onDone: () => print('MQTT stream closed'),
        );
      } else {
        print('MQTT connection failed - status: ${_client.connectionStatus}');
      }

      _isConnected = _client.connectionStatus!.state == MqttConnectionState.connected;
    } catch (e) {
      print('MQTT error: $e');
      _isConnected = false;
      disconnect();
    }
  }

  void disconnect() {
    if (_isConnected) {
      _client.disconnect();
      _isConnected = false;
      print('MQTT disconnected');
    }
  }

  bool get isConnected => _isConnected;

  void _handleDisconnected() {
    print('MQTT disconnected callback');
    _isConnected = false;
    onDisconnected?.call();
  }

  void _handleConnected() {
    print('MQTT connected callback');
    onConnected?.call();
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }
}
