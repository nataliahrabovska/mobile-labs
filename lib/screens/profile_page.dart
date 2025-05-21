import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text;
    print('Saved name: $name');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Color(0xFF292828))),
        backgroundColor: Color(0xFFFFFCF6),
        iconTheme: IconThemeData(color: Color(0xFF292828)),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
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
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'User Name',
                  hintStyle: TextStyle(color: Color(0xFF292828)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
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
