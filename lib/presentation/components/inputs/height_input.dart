import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class HeightInput extends StatelessWidget {
  const HeightInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your height';
          }

          formCubit.onInputChanged(key: 'height', value: double.parse(value));
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Height (ft)',
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
