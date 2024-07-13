import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/components/auth/register/athlete_form.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RegisterAthleteForm extends StatelessWidget {
  const RegisterAthleteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              AutoSizeText(
                "ATHLETE INFORMATION",
                style: TextStyle(
                  color: ThemeColor.primary,
                  letterSpacing: 1.2,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              AutoSizeText(
                'Please fill in the following information to complete your registration.',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 25),
              AthleteForm(),
            ],
          ),
        ),
      ),
    );
  }
}
