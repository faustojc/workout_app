import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class BirthdayInput extends HookWidget {
  const BirthdayInput({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);
    final controller = useTextEditingController();

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      builder: (context, state) => TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Birthday',
          labelStyle: TextStyle(color: Colors.white),
          suffixIcon: Icon(Icons.calendar_month, color: ThemeColor.primary),
          suffixIconColor: ThemeColor.primary,
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeColor.primary)),
        ),
        onTap: () async {
          await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            initialDate: state is FormInputChanged ? state.repo.data['birthday'] : DateTime.now(),
            currentDate: state is FormInputChanged ? state.repo.data['birthday'] : DateTime.now(),
            builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(colorScheme: const ColorScheme.dark(primary: ThemeColor.primary)),
              child: child!,
            ),
          ).then((date) {
            if (date != null) {
              formCubit.onInputChanged(key: 'birthday', value: date);
              controller.text = DateFormat.yMMMMd().format(date);
            }
          });
        },
      ),
    );
  }
}
