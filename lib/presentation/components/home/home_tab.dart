import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/presentation/blocs/home/home_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class HomeTab extends StatelessWidget {
  final int index;
  final IconData icon;

  const HomeTab({required this.index, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, int>(
      builder: (context, state) => Tab(
        icon: Icon(icon, color: (state == index) ? ThemeColor.primary : Colors.white),
      ),
    );
  }
}
