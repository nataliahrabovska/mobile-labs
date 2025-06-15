import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', width: 200),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter email';
              if (!value.contains('@')) return 'Enter valid email';
              return null;
            },
            onChanged: (value) => email = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (value.length < 6) return 'Password too short';
              return null;
            },
            onChanged: (value) => password = value,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().register(email, password).then((_) {
                    context.read<AuthCubit>().login(email, password);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBD59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: state is AuthLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                'Register',
                style: TextStyle(color: Color(0xFF292828)),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Already have an account? Login Here",
              style: TextStyle(color: Color(0xFF292828)),
            ),
          ),
        ],
      ),
    );
  }
}
