import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HedgehogCounter(),
    );
  }
}

class HedgehogCounter extends StatefulWidget {
  @override
  _HedgehogCounterState createState() => _HedgehogCounterState();
}

class _HedgehogCounterState extends State<HedgehogCounter> {
  int _hedgehogCount = 0;
  String _message = "";
  final TextEditingController _controller = TextEditingController();

  void _updateCounter(String input) {
    String trimmedInput = input.trim();

    if (trimmedInput == "я не знаю коду") {
      setState(() {
        _hedgehogCount = 0;
        _message = "На перездачу!";
      });
    } else {
      int? value = int.tryParse(trimmedInput);
      if (value != null) {
        setState(() {
          _hedgehogCount += value;
          _message = "";
        });
      }
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Лічильник їжаків")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${"🦔" * _hedgehogCount}",
              style: TextStyle(fontSize: 30),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  _message,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Введіть число або текст...",
                ),
                onSubmitted: _updateCounter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
