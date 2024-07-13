import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/components/auth/register/register_create_user_button.dart';
import 'package:workout_routine/presentation/components/inputs/address_input.dart';
import 'package:workout_routine/presentation/components/inputs/age_input.dart';
import 'package:workout_routine/presentation/components/inputs/birthday_input.dart';
import 'package:workout_routine/presentation/components/inputs/city_input.dart';
import 'package:workout_routine/presentation/components/inputs/firstname_input.dart';
import 'package:workout_routine/presentation/components/inputs/height_input.dart';
import 'package:workout_routine/presentation/components/inputs/lastname_input.dart';
import 'package:workout_routine/presentation/components/inputs/sex_input.dart';
import 'package:workout_routine/presentation/components/inputs/weight_input.dart';

class AthleteForm extends StatefulWidget {
  const AthleteForm({super.key});

  @override
  State<AthleteForm> createState() => _AthleteFormState();
}

class _AthleteFormState extends State<AthleteForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const FirstnameInput(),
          const SizedBox(height: 15),
          const LastnameInput(),
          const SizedBox(height: 15),
          const BirthdayInput(),
          const SizedBox(height: 15),
          const AgeInput(),
          const SizedBox(height: 15),
          const SexInput(),
          const SizedBox(height: 15),
          const HeightInput(),
          const SizedBox(height: 15),
          const WeightInput(),
          const SizedBox(height: 15),
          const CityInput(),
          const SizedBox(height: 15),
          const AddressInput(),
          const SizedBox(height: 40),
          RegisterCreateUserButton(formKey: _formKey),
        ],
      ),
    );
  }
}
