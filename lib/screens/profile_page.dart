import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // для переходу на login після logout

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  void _saveName() {
    final name = _nameController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Name saved: $name')),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFFFFCF6),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF292828)),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
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
              _buildTextField('User Name', _nameController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFBD59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Save',
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

Widget _buildTextField(String hint, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF292828)),
    ),
  );
}
