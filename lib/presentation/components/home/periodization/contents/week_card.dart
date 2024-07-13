import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:workout_routine/data/models/week.dart';
import 'package:workout_routine/domain/providers/image_path_provider.dart';
import 'package:workout_routine/presentation/components/shared/empty_content.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

import 'day_container.dart';

class WeekCard extends HookWidget {
  final Week week;
  final List<Map<String, dynamic>> days;

  const WeekCard({required this.week, required this.days, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColor.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: AutoSizeText(
              week.title!.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                color: ThemeColor.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.5,
              ),
            ),
          ),
          const VerticalDivider(
            color: ThemeColor.lightGrey,
            thickness: 3.5,
            width: 25,
            indent: 20,
            endIndent: 20,
          ),
          (days.isEmpty)
              ? const Expanded(
                  child: EmptyContent(
                    imagePath: ImagePathProvider.noDates,
                    title: "No days schedule yet",
                    imgScale: 4.3,
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: days //
                          .map((item) => DayContainer(day: item['day'], status: item['status']))
                          .toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
