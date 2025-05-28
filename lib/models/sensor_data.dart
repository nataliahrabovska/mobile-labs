class SensorData {
  final String location;
  final double temperature;
  final double humidity;
  final String timestamp;

  SensorData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      location: json['location'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location,
    'temperature': temperature,
    'humidity': humidity,
    'timestamp': timestamp,
  };
}
