import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/components/auth/auth_confirm_pass_input.dart';
import 'package:workout_routine/presentation/components/auth/auth_email_input.dart';
import 'package:workout_routine/presentation/components/auth/auth_password_input.dart';
import 'package:workout_routine/presentation/components/auth/auth_request_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthEmailInput(),
          const SizedBox(height: 20),
          const AuthPasswordInput(registering: true),
          const SizedBox(height: 20),
          const AuthConfirmPassInput(),
          const SizedBox(height: 30),
          AuthRequestButton(text: 'Register', formKey: _formKey, registering: true),
        ],
      ),
    );
  }
}
