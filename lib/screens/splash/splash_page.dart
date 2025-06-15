import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loggedIn = snapshot.data == true;
        return loggedIn ? const HomePage() : const LoginPage();
      },
    );
  }
}
