import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFFFFCF6),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => print('Change Avatar'),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile_photo.png'),
                ),
              ),
              SizedBox(height: 10),
              _buildTextField('User Name'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(String hint) {
  return TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF292828)),
    ),
  );
}
