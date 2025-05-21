import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFBD59),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF292828),
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF292828),
            ),
          ),
        ],
      ),
    );
  }
}

