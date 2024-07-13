import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class SexInput extends StatelessWidget {
  const SexInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => DropdownButtonFormField(
        style: const TextStyle(color: Colors.white),
        dropdownColor: ThemeColor.grey,
        validator: (value) => value == null || value.isEmpty ? 'Please select your sex' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => formCubit.onInputChanged(key: 'sex', value: value),
        decoration: const InputDecoration(
          labelText: 'Sex',
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeColor.primary)),
        ),
        items: const [
          DropdownMenuItem<String>(value: 'male', child: Text('Male')),
          DropdownMenuItem<String>(value: 'female', child: Text('Female')),
        ],
      ),
    );
  }
}
