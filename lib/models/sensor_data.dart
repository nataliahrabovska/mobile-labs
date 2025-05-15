class SensorData {
  final String location;
  final String temperature;
  final String humidity;
  final String date;

  SensorData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'location': location,
    'temperature': temperature,
    'humidity': humidity,
    'date': date,
  };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
    location: json['location'],
    temperature: json['temperature'],
    humidity: json['humidity'],
    date: json['date'],
  );
}