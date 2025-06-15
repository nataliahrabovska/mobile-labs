import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_cubit.dart';
import 'profile_state.dart';
import 'profile_form.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved')),
          );
        } else if (state is ProfileLoggedOut) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFCF6),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFCF6),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Color(0xFF292828)),
          title: const Text(
            'Profile',
            style: TextStyle(color: Color(0xFF292828)),
          ),
        ),
        body: const SafeArea(child: ProfileForm()),
      ),
    );
  }
}
