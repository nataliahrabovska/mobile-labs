import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';

class MqttService {
  final _client = MqttServerClient('broker.hivemq.com', 'grainDocClient')
    ..port = 1883
    ..logging(on: true)  // Включаємо логування для детальної перевірки
    ..keepAlivePeriod = 20;

  Function(SensorData)? onDataReceived;
  Function()? onDisconnected;
  Function()? onConnected;
  bool _isConnected = false;

  Future<void> connect() async {
    try {
      _client.onConnected = _handleConnected;
      _client.onDisconnected = _handleDisconnected;
      _client.onSubscribed = _onSubscribed;

      final connMess = MqttConnectMessage()
          .withClientIdentifier('grainDocClient')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      _client.connectionMessage = connMess;

      await _client.connect();

      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT connected');
        _client.subscribe('grainDoc/sensor', MqttQos.atLeastOnce);

        _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
          final recMess = messages[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          print('Received message: $payload');  // Лог для перевірки отриманого повідомлення

          try {
            final Map<String, dynamic> json = jsonDecode(payload);
            final data = SensorData.fromJson(json);
            print('Decoded data: ${data.toJson()}');  // Лог для перевірки декодованих даних
            onDataReceived?.call(data);
          } catch (e) {
            print('MQTT JSON decode error: $e');
          }
        });
      } else {
        print('MQTT connection failed');
      }

      _isConnected = true;
    } catch (e) {
      print('MQTT error: $e');
      _isConnected = false;
      disconnect();  // Disconnect if connection fails
    }
  }

  void disconnect() {
    if (_isConnected) {
      _client.disconnect();
      _isConnected = false;
    }
  }

  bool get isConnected => _isConnected;

  void _handleDisconnected() {
    print('MQTT disconnected');
    _isConnected = false;
    onDisconnected?.call();
  }

  void _handleConnected() {
    print('MQTT connected');
    onConnected?.call();
  }

  void _onSubscribed(String topic) {
    print('Subscribed to $topic');
  }
}
