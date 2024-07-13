import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/pages/auth/login_page.dart';
import 'package:workout_routine/presentation/pages/auth/register_page.dart';
import 'package:workout_routine/presentation/pages/user/home_page.dart';
import 'package:workout_routine/presentation/pages/user/periodization_page.dart';
import 'package:workout_routine/presentation/pages/user/workout_schedule_page.dart';

// All routes
class Routes {
  static MaterialPageRoute<LoginPage> login = MaterialPageRoute(builder: (_) => const LoginPage());

  static MaterialPageRoute<RegisterPage> register = MaterialPageRoute(builder: (_) => const RegisterPage());

  static MaterialPageRoute<HomePage> home = MaterialPageRoute(builder: (_) => const HomePage());

  static MaterialPageRoute<PeriodizationPage> periodization = MaterialPageRoute(builder: (_) => const PeriodizationPage());

  static PageRouteBuilder<WorkoutSchedulePage> workoutSchedule = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const WorkoutSchedulePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutSine));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );

  static final List<PageRoute> allRoutes = [
    login,
    register,
    home,
    periodization,
    workoutSchedule,
  ];
}
