import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/data/models/day.dart';
import 'package:workout_routine/data/models/user_workout.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class DayContainer extends StatelessWidget {
  final Day day;
  final UserWorkoutStatus status;

  const DayContainer({required this.day, required this.status, super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            day.title!,
            style: const TextStyle(color: ThemeColor.primary),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 65,
              height: 100,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: (status == UserWorkoutStatus.completed) ? ThemeColor.primary : ThemeColor.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      );
}
