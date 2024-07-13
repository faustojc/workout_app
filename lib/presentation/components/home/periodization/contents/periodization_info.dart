import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/periodization_repo.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class PeriodizationInfo extends StatelessWidget {
  const PeriodizationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = RepositoryProvider.of<PeriodizationRepo>(context);

    return Column(
      children: [
        AutoSizeText(
          repo.periodization.acronym ?? repo.periodization.name!,
          style: const TextStyle(fontSize: 50, color: ThemeColor.primary, fontWeight: FontWeight.w600),
        ),
        AutoSizeText(
          repo.periodization.name!,
          style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: AnimatedReadMoreText(
            repo.periodization.description!,
            maxLines: 2,
            readMoreText: ' show more',
            readLessText: ' show less',
            textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
            buttonTextStyle: const TextStyle(color: Colors.grey, fontSize: 14.5),
          ),
        )
      ],
    );
  }
}
