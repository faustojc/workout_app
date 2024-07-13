import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AuthLogoutButton extends StatelessWidget {
  const AuthLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is AuthLoading) {
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: ThemeColor.black),
              ));
        }

        return ElevatedButton(
            onPressed: () => authBloc.add(AuthLogout()),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: ThemeColor.black, fontSize: 16, fontWeight: FontWeight.bold),
            ));
      },
    );
  }
}
