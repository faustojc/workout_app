import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AuthConfirmPassInput extends HookWidget {
  const AuthConfirmPassInput({super.key});

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
        return prev is FormInputChanged && curr is FormInputChanged && prev.repo.data != curr.repo.data;
      },
      builder: (context, state) => TextFormField(
        style: const TextStyle(color: Colors.white),
        obscureText: obscure.value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          } else if (state is FormInputChanged && value != state.repo.data['password']) {
            return 'Passwords do not match';
          }

          formCubit.onInputChanged(key: 'confirm_password', value: value);
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
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
