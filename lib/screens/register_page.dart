import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String phone = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(90),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 300),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    if (!value.contains('@')) return 'Enter valid email';
                    return null;
                  },
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter phone';
                    if (!RegExp(r'^\+?[0-9]{7,}$').hasMatch(value)) {
                      return 'Enter valid phone';
                    }
                    return null;
                  },
                  onChanged: (value) => phone = value,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter password';
                    if (value.length < 6) return 'Password too short';
                    return null;
                  },
                  onChanged: (value) => password = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFBD59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Color(0xFF292828)),
                  ),
                ),
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
      ),
    );
  }
}
