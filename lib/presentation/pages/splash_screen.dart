import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/blocs/periodization/periodization_cubit.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);
    final periodizationCubit = BlocProvider.of<PeriodizationCubit>(context);

    return BlocListener(
      bloc: authBloc,
      listener: (context, state) async {
        if (state is Authenticated) {
          await Future.wait([
            userCubit.onFetchData(userId: state.user.id),
            periodizationCubit.onFetchPeriodization(),
          ]);

          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context, Routes.home, (route) => false);
          }
        } else if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(context, Routes.login, (route) => false);
        }

        FlutterNativeSplash.remove();
      },
      child: Container(),
    );
  }
}
