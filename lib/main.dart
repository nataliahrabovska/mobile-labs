import 'package:flutter/material.dart';
import 'package:test_lab2/screens/login_page.dart';
import 'package:test_lab2/screens/profile_page.dart';
import 'package:test_lab2/screens/register_page.dart';
import 'services/auth_service.dart';
import 'package:test_lab2/screens/home_page.dart'; // додайте цей рядок


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(fontFamily: 'Roboto'),
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: _authService.isLoggedIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox(); // splash screen
            return snapshot.data! ? HomePage() : LoginPage();
          },
        ),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
