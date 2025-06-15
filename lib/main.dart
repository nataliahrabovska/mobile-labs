import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_lab2/screens/home/home_page.dart';
import 'package:test_lab2/screens/login/login_page.dart';
import 'package:test_lab2/screens/profile/profile_page.dart';
import 'package:test_lab2/screens/register/register_page.dart';
import 'package:test_lab2/screens/scanner/qr_scanner/qr_scanner_screen.dart' as qr;
import 'package:test_lab2/screens/scanner/saved_qr/saved_qr_screen.dart' as saved;
import 'package:test_lab2/screens/splash/splash_page.dart';

void main() {
  Bloc.observer = AppBlocObserver(); // optional logging
  runApp(const GrainDocApp());
}

class GrainDocApp extends StatelessWidget {
  const GrainDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrainDoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFFCF6),
      ),
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/qr': (context) => const qr.QRScannerScreen(),
        '/saved': (context) => const saved.SavedQrScreen(),
      },
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🌀 ${bloc.runtimeType} → $transition');
  }
}
