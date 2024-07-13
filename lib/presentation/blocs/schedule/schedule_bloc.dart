import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workout_routine/data/models/user_workout.dart';
import 'package:workout_routine/data/models/week.dart';
import 'package:workout_routine/domain/repositories/periodization_repo.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/domain/repositories/workout_repo.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final PeriodizationRepo _periodizationRepo;
  final WorkoutRepo _workoutRepo;
  final UserRepo _userRepo;
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 4,
      printEmojis: false,
      printTime: true,
    ),
  );

  ScheduleBloc({
    required PeriodizationRepo periodizationRepo,
    required WorkoutRepo workoutRepo,
    required UserRepo userRepo,
  })  : _periodizationRepo = periodizationRepo,
        _workoutRepo = workoutRepo,
        _userRepo = userRepo,
        super(ScheduleInitial()) {
    on<ScheduleFetchData>((event, emit) async {
      emit(ScheduleLoading());

      try {
        await Future.wait([
          _periodizationRepo.fetchDates(_periodizationRepo.periodization.id!),
          _workoutRepo.fetchWorkoutCategoryData(_periodizationRepo.periodization.id!),
          _workoutRepo.fetchWorkoutsFromPeriodization(_periodizationRepo.periodization.id!),
        ]);

        final weeks = _periodizationRepo.weeks //
            .where((week) => week.periodizationId == _periodizationRepo.periodization.id!)
            .map((week) => {
                  'week': week,
                  'days': _getDaysInWeek(week),
                })
            .toList();

        if (weeks.isNotEmpty) {
          emit(ScheduleLoaded(weeks));
        } else {
          emit(ScheduleNoData());
        }
      } catch (err) {
        logger.e(err.toString());
        emit(ScheduleError(err.toString()));
      }
    }, transformer: droppable());
  }

  List<Map<String, dynamic>> _getDaysInWeek(Week week) {
    final List<Map<String, dynamic>> data = [];
    final days = _periodizationRepo.days.where((day) => day.weeksId == week.id).toList();

    if (days.isNotEmpty) {
      for (final day in days) {
        if (_workoutRepo.workoutCategories.isEmpty || _userRepo.userWorkouts.isEmpty) {
          data.add({
            'day': day,
            'status': UserWorkoutStatus.incomplete,
          });
        } else {
          final isAllCategoriesComplete = _workoutRepo.workoutCategories //
              .where((workoutCategory) => workoutCategory.daysId == day.id)
              .every((workoutCategory) => _userRepo.userWorkouts //
                  .where((userWorkout) => userWorkout.workoutCategoryId == workoutCategory.id)
                  .every((userWorkout) => userWorkout.status == UserWorkoutStatus.completed));

          data.add({
            'day': day,
            'status': isAllCategoriesComplete ? UserWorkoutStatus.completed : UserWorkoutStatus.incomplete,
          });
        }
      }
    }

    return data;
  }
}
