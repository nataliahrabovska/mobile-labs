import 'package:flutter/material.dart';
import 'package:test_lab2/screens/scanner/qr_scanner_screen.dart' as qr;
import 'package:test_lab2/screens/scanner/saved_qr_screen.dart' as saved;

import 'services/auth_service.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/register_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(GrainDocApp());
}

class GrainDocApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrainDoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Color(0xFFFFFCF6),
      ),
      home: FutureBuilder<bool>(
        future: _authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return snapshot.data == true ? HomePage() : LoginPage();
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/qr': (context) => qr.QRScannerScreen(),
        '/saved': (context) => saved.SavedQrScreen(),
      },
    );
  }
}
