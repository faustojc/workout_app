import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class CityInput extends StatelessWidget {
  const CityInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'City is required';
          }

          formCubit.onInputChanged(key: 'city', value: value);
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelText: 'City',
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeColor.primary)),
        ),
      ),
    );
  }
}
