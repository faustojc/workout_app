import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AgeInput extends StatelessWidget {
  const AgeInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your age';
          } else if (int.tryParse(value) == null) {
            return 'Please enter a valid age';
          }

          formCubit.onInputChanged(key: 'age', value: int.parse(value));
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelText: 'Age',
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
