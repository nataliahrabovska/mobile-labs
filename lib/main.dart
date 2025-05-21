import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/profile_page.dart';
import 'screens/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(GrainDocApp(isLoggedIn: isLoggedIn));
}

class GrainDocApp extends StatelessWidget {
  final bool isLoggedIn;

  const GrainDocApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrainDoc',
      theme: AppTheme.lightTheme,
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
