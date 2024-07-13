import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/periodization_repo.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/domain/repositories/workout_repo.dart';
import 'package:workout_routine/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:workout_routine/presentation/components/home/periodization/contents/periodization_info.dart';
import 'package:workout_routine/presentation/components/home/periodization/contents/week_list.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class WorkoutSchedulePage extends StatelessWidget {
  const WorkoutSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) => ScheduleBloc(
        periodizationRepo: RepositoryProvider.of<PeriodizationRepo>(context),
        workoutRepo: RepositoryProvider.of<WorkoutRepo>(context),
        userRepo: RepositoryProvider.of<UserRepo>(context),
      ),
      child: Scaffold(
        backgroundColor: ThemeColor.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Hero(
            tag: 'periodization',
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, color: ThemeColor.primary),
            ),
          ),
        ),
        body: const ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PeriodizationInfo(),
                SizedBox(height: 20),
                WeekList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
