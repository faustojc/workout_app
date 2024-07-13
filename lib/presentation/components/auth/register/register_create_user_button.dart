import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/auth_repo.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RegisterCreateUserButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const RegisterCreateUserButton({required this.formKey, super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormInputCubit>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<FormInputCubit, FormInputState>(
          listenWhen: (prev, curr) => curr is FormSubmitting,
          listener: (context, state) async {
            if (state is FormSubmitting) {
              FocusScope.of(context).unfocus();

              await userCubit.onCreateUser(
                userId: context.read<AuthRepo>().auth.currentUser!.id,
                data: state.data,
              );
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          listenWhen: (prev, curr) => curr is UserSuccess || curr is UserError,
          listener: (context, state) {
            if (state is UserSuccess) {
              formCubit.onFormSuccess();
            } else if (state is UserError) {
              formCubit.onFormError(message: state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<FormInputCubit, FormInputState>(
        bloc: formCubit,
        buildWhen: (prev, curr) => curr is FormSubmitting || curr is FormSuccess || curr is FormFailure,
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
            onPressed: () {
              FocusScope.of(context).unfocus();

              if (formKey.currentState!.validate()) {
                formCubit.onFormSubmit();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            ),
            child: const Text('Create', style: TextStyle(color: ThemeColor.black, fontSize: 18)),
          );
        },
      ),
    );
  }
}
