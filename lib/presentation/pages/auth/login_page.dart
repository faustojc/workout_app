import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/blocs/periodization/periodization_cubit.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';
import 'package:workout_routine/presentation/components/auth/login/login_form.dart';
import 'package:workout_routine/presentation/components/auth/top_navigation.dart';
import 'package:workout_routine/presentation/components/shared/status_alert_dialog.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);
    final periodizationCubit = BlocProvider.of<PeriodizationCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeColor.black,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listenWhen: (prev, curr) => curr is Authenticated || curr is AuthNotValidated || curr is AuthFailed,
            listener: (context, state) async {
              if (state is AuthFailed) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ));
              } else if (state is Authenticated) {
                await userCubit.onFetchData(userId: state.user.id);
              } else if (state is AuthNotValidated) {
                showDialog(
                  context: context,
                  builder: (context) => StatusAlertDialog(
                    title: const Text("Email Not Verified", style: TextStyle(color: ThemeColor.primary)),
                    statusIndicator: const Icon(Icons.do_not_disturb, color: Colors.redAccent, size: 50),
                    statusMessage: "You have not verified your email yet. Please check your email and verify to continue",
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text('Ok', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
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
                  await periodizationCubit.onFetchPeriodization();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context, Routes.home, (route) => false);
                  }
                } else if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ));
                }
              }),
        ],
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Hero(
                  tag: 'auth_top_nav',
                  child: TopNavigation(registerRoute: Routes.register),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/logo-white.png',
                            height: 150,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(height: 40),
                          const LoginForm(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
