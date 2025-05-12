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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', width: 90),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter email';
                          if (!value.contains('@')) return 'Enter valid email';
                          return null;
                        },
                        onChanged: (value) => email = value,
                      ),
                      SizedBox(height: 16),
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
                      SizedBox(height: 16),
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
                      SizedBox(height: 30),
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
        },
      ),
    );
  }
}
