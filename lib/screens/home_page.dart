import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../models/sensor_data.dart';
import '../services/local_storage.dart';
import '../services/mqtt_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SensorData> dataList = [];
  final storage = LocalStorageService();
  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    _mqttService.onDataReceived = _onDataReceived;
    _connectToMqtt();
    loadData();
  }

  Future<void> loadData() async {
    final data = await storage.loadData();
    setState(() {
      dataList = data;
    });
  }

  void _connectToMqtt() async {
    try {
      await _mqttService.connect();
      if (_mqttService.isConnected) {
        print('✅ MQTT Connected');
      } else {
        print('❌ MQTT connection failed');
      }
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDataReceived(SensorData newData) async {
    bool exists = dataList.any((d) =>
    d.timestamp == newData.timestamp && d.location == newData.location);
    if (!exists) {
      setState(() {
        dataList.add(newData);
      });
      await storage.addNewData(newData);
    }
  }

  double get averageTemperature {
    if (dataList.isEmpty) return 0.0;
    final total = dataList.map((d) => d.temperature).reduce((a, b) => a + b);
    return total / dataList.length;
  }

  double get averageHumidity {
    if (dataList.isEmpty) return 0.0;
    final total = dataList.map((d) => d.humidity).reduce((a, b) => a + b);
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
              _buildDialogTextField(dateController, 'Date (DD/MM/YYYY HH:mm:ss)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              locationController.dispose();
              tempController.dispose();
              humidityController.dispose();
              dateController.dispose();
            },
            child: Text('Cancel', style: TextStyle(color: Color(0xFF292828))),
          ),
          ElevatedButton(
            onPressed: () async {
              final newData = SensorData(
                location: locationController.text,
                temperature: double.tryParse(tempController.text) ?? 0.0,
                humidity: double.tryParse(humidityController.text) ?? 0.0,
                timestamp: dateController.text,
              );
              await storage.addNewData(newData);
              setState(() {
                dataList.add(newData);
              });

              Navigator.pop(context);
              locationController.dispose();
              tempController.dispose();
              humidityController.dispose();
              dateController.dispose();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFBD59)),
            child: Text('Add', style: TextStyle(color: Color(0xFF292828))),
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
              setState(() {
                dataList.remove(item);
              });
              Navigator.pop(context);
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

  void _showEditDataDialog(SensorData item) {
    final locationController = TextEditingController(text: item.location);
    final tempController = TextEditingController(text: item.temperature.toString());
    final humidityController = TextEditingController(text: item.humidity.toString());
    final dateController = TextEditingController(text: item.timestamp);

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
              _buildDialogTextField(dateController, 'Date (DD/MM/YYYY HH:mm:ss)'),
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
                    locationController.dispose();
                    tempController.dispose();
                    humidityController.dispose();
                    dateController.dispose();
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
                    setState(() {
                      dataList.remove(item);
                    });

                    final updatedData = SensorData(
                      location: locationController.text,
                      temperature: double.tryParse(tempController.text) ?? 0.0,
                      humidity: double.tryParse(humidityController.text) ?? 0.0,
                      timestamp: dateController.text,
                    );
                    await storage.addNewData(updatedData);
                    setState(() {
                      dataList.add(updatedData);
                    });

                    Navigator.pop(context);
                    locationController.dispose();
                    tempController.dispose();
                    humidityController.dispose();
                    dateController.dispose();

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

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
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
            child: Column(
              children: [
                ElevatedButton(
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
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/qr'),
                  icon: Icon(Icons.qr_code_scanner, color: Color(0xFF292828)),
                  label: Text('Scanner QR', style: TextStyle(color: Color(0xFF292828))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE7E7E7),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/saved'),
                  icon: Icon(Icons.save, color: Color(0xFF292828)),
                  label: Text('View message', style: TextStyle(color: Color(0xFF292828))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE7E7E7),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
