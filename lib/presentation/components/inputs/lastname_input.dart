import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class LastnameInput extends StatelessWidget {
  const LastnameInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }

          formCubit.onInputChanged(key: 'firstname', value: value);
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Last Name',
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
