import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:workout_routine/domain/repositories/form_repo.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/blocs/form/form_input_cubit.dart';
import 'package:workout_routine/presentation/blocs/periodization/periodization_cubit.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';
import 'package:workout_routine/presentation/components/auth/register/register_athlete_form.dart';
import 'package:workout_routine/presentation/components/auth/register/register_user_form.dart';
import 'package:workout_routine/presentation/components/shared/status_alert_dialog.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);
    final pageController = usePageController();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (prev, curr) => curr is Authenticated || curr is AuthFailed,
          listener: (context, state) async {
            if (state is AuthFailed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ));
            }

            if (state is Authenticated) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => StatusAlertDialog(
                  statusIndicator: const Text('VERIFICATION',
                      style: TextStyle(
                        color: ThemeColor.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  statusMessage: "Check your email to verify your account",
                  actions: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: const Text('Continue', style: TextStyle(color: ThemeColor.black, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          bloc: userCubit,
          listenWhen: (prev, curr) => curr is UserSuccess || curr is UserError,
          listener: (context, state) async {
            if (state is UserSuccess) {
              await context.read<PeriodizationCubit>().onFetchPeriodization();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, Routes.login, (route) => false);
              }
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ));
            }
          },
        ),
      ],
      child: BlocProvider(
        create: (context) => FormInputCubit(
          formRepo: RepositoryProvider.of<FormRepo>(context),
        ),
        child: SizedBox.expand(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/backgrounds/register_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const RegisterUserForm(),
                ],
              ),
              const RegisterAthleteForm(),
            ],
          ),
        ),
      ),
    );
  }
}
