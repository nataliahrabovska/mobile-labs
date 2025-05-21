import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 300),
              _buildTextField('Email'),
              _buildTextField('Password', obscureText: true),
              SizedBox(height: 20),
              _buildButton('Login', () => _login(context)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  "Don't have an account? Sign up Here",
                  style: TextStyle(color: Color(0xFF292828)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(String hint, {bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF292828)),
    ),
  );
}

Widget _buildButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFBD59),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(color: Color(0xFF292828)),
    ),
  );
}
