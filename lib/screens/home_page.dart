import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../models/sensor_data.dart';
import '../services/local_storage.dart';
import 'dart:async';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SensorData> dataList = [];
  final storage = LocalStorageService();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    loadData();
    startDataUpdateTimer();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void startDataUpdateTimer() {
    _updateTimer = Timer.periodic(Duration(seconds: 10), (_) {
      updateRandomly();
    });
  }

  void updateRandomly() async {
    final random = Random();
    final updatedList = dataList.map((data) {
      double temp = double.tryParse(data.temperature) ?? 25.0;
      double hum = double.tryParse(data.humidity) ?? 50.0;

      temp += (random.nextDouble() * 3 - 1.5);
      hum += (random.nextDouble() * 3 - 1.5);

      temp = temp.clamp(15.0, 35.0);
      hum = hum.clamp(30.0, 80.0);

      return SensorData(
        location: data.location,
        temperature: temp.toStringAsFixed(1),
        humidity: hum.toStringAsFixed(1),
        date: DateTime.now().toString().substring(0, 10),
      );
    }).toList();

    await storage.saveData(updatedList);
    setState(() {
      dataList = updatedList;
    });
  }

  Future<void> loadData() async {
    final data = await storage.loadData();
    if (data.isEmpty) {
      final randomData = List.generate(10, (_) => generateRandomSensorData());
      await storage.saveData(randomData);
      setState(() {
        dataList = randomData;
      });
    } else {
      setState(() {
        dataList = data;
      });
    }
  }


  double get averageTemperature {
    if (dataList.isEmpty) return 0.0;
    final total = dataList
        .map((d) => double.tryParse(d.temperature) ?? 0.0)
        .reduce((a, b) => a + b);
    return total / dataList.length;
  }

  double get averageHumidity {
    if (dataList.isEmpty) return 0.0;
    final total = dataList
        .map((d) => double.tryParse(d.humidity) ?? 0.0)
        .reduce((a, b) => a + b);
    return total / dataList.length;
  }

  void _showAddDataDialog() {
    final locationController = TextEditingController();
    final tempController = TextEditingController();
    final humidityController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFFCF6),
        title: Text('Add New Sensor Data'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildDialogTextField(locationController, 'Location'),
              _buildDialogTextField(tempController, 'Temperature'),
              _buildDialogTextField(humidityController, 'Humidity'),
              _buildDialogTextField(dateController, 'Date (DD/MM/YYYY)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF292828))),
          ),
          ElevatedButton(
            onPressed: () async {
              final newData = SensorData(
                location: locationController.text,
                temperature: tempController.text,
                humidity: humidityController.text,
                date: dateController.text,
              );
              await storage.addNewData(newData);
              Navigator.pop(context);
              await loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFBD59),
            ),
            child: Text('Add', style: TextStyle(color: Color(0xFF292828))),
          ),
        ],
      ),
    );
  }

  void _showEditDataDialog(SensorData item) {
    final locationController = TextEditingController(text: item.location);
    final tempController = TextEditingController(text: item.temperature);
    final humidityController = TextEditingController(text: item.humidity);
    final dateController = TextEditingController(text: item.date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFFCF6),
        title: Text('Edit Sensor Data'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildDialogTextField(locationController, 'Location'),
              _buildDialogTextField(tempController, 'Temperature'),
              _buildDialogTextField(humidityController, 'Humidity'),
              _buildDialogTextField(dateController, 'Date (DD/MM/YYYY)'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await storage.deleteData(item);
                    final updatedData = SensorData(
                      location: locationController.text,
                      temperature: tempController.text,
                      humidity: humidityController.text,
                      date: dateController.text,
                    );
                    await storage.addNewData(updatedData);
                    Navigator.pop(context);
                    await loadData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Дані оновлено')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFBD59),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Update', style: TextStyle(color: Color(0xFF292828))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SensorData generateRandomSensorData() {
    final random = Random();
    final locations = ['Bin A', 'Bin B', 'Bin C', 'Warehouse', 'Storage 1'];
    final location = locations[random.nextInt(locations.length)];

    final temperature = (18 + random.nextDouble() * 12).toStringAsFixed(1); // 18.0–30.0 °C
    final humidity = (40 + random.nextDouble() * 30).toStringAsFixed(1);   // 40–70 %
    final date = DateTime.now().toString().substring(0, 10); // YYYY-MM-DD

    return SensorData(
      location: location,
      temperature: temperature,
      humidity: humidity,
      date: date,
    );
  }


  void _showDeleteConfirmationDialog(SensorData item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFFCF6),
        title: Text('Delete Sensor Data'),
        content: Text('Are you sure you want to delete this data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF292828))),
          ),
          ElevatedButton(
            onPressed: () async {
              await storage.deleteData(item);
              Navigator.pop(context);
              await loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFBD59),
            ),
            child: Text('Delete', style: TextStyle(color: Color(0xFF292828))),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF292828)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFFCF6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo_home.png', width: 120),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile_photo.png'),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoCard(title: 'Avg Temp', value: '${averageTemperature.toStringAsFixed(1)}°C'),
                InfoCard(title: 'Avg Humidity', value: '${averageHumidity.toStringAsFixed(1)}%'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFFFFCF6),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
                  return ListTile(
                    title: Text(item.location, style: TextStyle(color: Color(0xFF292828))),
                    subtitle: Text(
                      'Temp: ${item.temperature}, Humidity: ${item.humidity}',
                      style: TextStyle(color: Color(0xFF292828)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF292828)),
                          onPressed: () => _showEditDataDialog(item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Color(0xFF292828)),
                          onPressed: () => _showDeleteConfirmationDialog(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _showAddDataDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFBD59),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Add New Data', style: TextStyle(color: Color(0xFF292828))),
            ),
          ),
        ],
      ),
    );
  }
}
