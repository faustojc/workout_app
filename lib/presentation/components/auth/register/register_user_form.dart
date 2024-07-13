import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/components/auth/register/register_form.dart';
import 'package:workout_routine/presentation/components/auth/top_navigation.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RegisterUserForm extends StatelessWidget {
  const RegisterUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Hero(tag: 'auth_top_nav', child: TopNavigation(loginRoute: Routes.login)),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              AutoSizeText(
                                "WELCOME",
                                style: TextStyle(
                                  color: ThemeColor.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              AutoSizeText(
                                "ATHLETES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          AutoSizeText(
                            "CREATE AN ACCOUNT TO START YOUR WORKOUT JOURNEY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                    decoration: const BoxDecoration(color: ThemeColor.black),
                    child: const RegisterForm(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
