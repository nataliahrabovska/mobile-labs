import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_lab2/screens/profile/profile_cubit.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => print('Change Avatar'),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_photo.png'),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'User Name',
                hintStyle: const TextStyle(color: Color(0xFF292828)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () =>
                  context.read<ProfileCubit>().saveName(controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBD59),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Save', style: TextStyle(color: Color(0xFF292828))),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Log out', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
