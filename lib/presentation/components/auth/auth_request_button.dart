import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AuthRequestButton extends StatelessWidget {
  final String text;
  final bool registering;

  final GlobalKey<FormState>? formKey;

  const AuthRequestButton({
    required this.text,
    this.registering = false,
    this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<FormInputCubit, FormInputState>(
          bloc: formCubit,
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            if (state is FormSubmitting) {
              authBloc.add(registering
                  ? AuthRegister(email: state.data['email'], password: state.data['password'])
                  : AuthLogin(email: state.data['email'], password: state.data['password']));
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            if (state is AuthFailed) {
              formCubit.onFormError(message: state.message);
            } else if (state is Authenticated) {
              formCubit.onFormSuccess();
            }
          },
        ),
      ],
      child: BlocBuilder<FormInputCubit, FormInputState>(
        bloc: formCubit,
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, state) {
          if (state is FormSubmitting) {
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: const CircularProgressIndicator(color: ThemeColor.black),
            );
          }

          return ElevatedButton(
            onPressed: () async {
              if (formKey != null && formKey!.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                formCubit.onFormSubmit();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            ),
            child: Text(text, style: const TextStyle(color: ThemeColor.black, fontSize: 18)),
          );
        },
      ),
    );
  }
}
