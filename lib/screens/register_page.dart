import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
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
              _buildTextField('Phone Number'),
              _buildTextField('Password', obscureText: true),
              SizedBox(height: 20),
              _buildButton('Register', () => Navigator.pushNamed(context, '/home')),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: Text(
                  "Have an account? Sign in Here",
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
