import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/form_repo.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/components/auth/auth_email_input.dart';
import 'package:workout_routine/presentation/components/auth/auth_password_input.dart';
import 'package:workout_routine/presentation/components/auth/auth_request_button.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormInputCubit(
        formRepo: RepositoryProvider.of<FormRepo>(context),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthEmailInput(),
              const SizedBox(height: 10),
              const AuthPasswordInput(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: ThemeColor.primary, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthRequestButton(text: 'Login', formKey: _formKey),
            ],
          ),
        ),
      ),
    );
  }
}
