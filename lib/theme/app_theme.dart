import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Color(0xFFFFFCF6),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF292828)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFBD59),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  );
}
