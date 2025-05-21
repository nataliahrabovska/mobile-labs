import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class HomePage extends StatelessWidget {
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
                InfoCard(title: 'Avg Temp', value: '20°C'),
                InfoCard(title: 'Avg Humidity', value: '60%'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFFFFCF6),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    'Location ${index + 1}',
                    style: TextStyle(color: Color(0xFF292828)),
                  ),
                  subtitle: Text(
                    'Temp: 20°C, Humidity: 60%',
                    style: TextStyle(color: Color(0xFF292828)),
                  ),
                  trailing: Text(
                    'Date: 26/03/2025',
                    style: TextStyle(color: Color(0xFF292828)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => print('Add Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFBD59),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Add New Data',
                style: TextStyle(color: Color(0xFF292828)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
