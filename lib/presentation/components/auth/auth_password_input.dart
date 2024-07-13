import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AuthPasswordInput extends HookWidget {
  final bool registering;

  const AuthPasswordInput({this.registering = false, super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);

    final obscure = useState<bool>(true);
    final obfuscateIcon = useState<IconButton?>(null);

    useEffect(() {
      if (obscure.value) {
        obfuscateIcon.value = IconButton(
          icon: const Icon(Icons.visibility, color: ThemeColor.primary),
          onPressed: () {
            obscure.value = false;
          },
        );
      } else {
        obfuscateIcon.value = IconButton(
          icon: const Icon(Icons.visibility_off, color: ThemeColor.primary),
          onPressed: () {
            obscure.value = true;
          },
        );
      }
      return null;
    }, [obscure.value]);

    return BlocBuilder<FormInputCubit, FormInputState>(
      bloc: formCubit,
      buildWhen: (prev, curr) {
        return prev is FormInputChanged && curr is FormInputChanged && prev.repo.data['password'] != curr.repo.data['password'];
      },
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        obscureText: obscure.value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }

          if (registering) {
            if (value.length < 6) {
              return 'At least 6 characters';
            } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(value)) {
              return 'At least 1 letter and 1 number';
            }
          }

          formCubit.onInputChanged(key: 'password', value: value);
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(Icons.lock_outline, color: ThemeColor.lightGrey),
          suffixIcon: obfuscateIcon.value,
          suffixIconColor: ThemeColor.primary,
          filled: true,
          fillColor: Colors.transparent,
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ThemeColor.primary)),
        ),
      ),
    );
  }
}
