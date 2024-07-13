import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/domain/repositories/workout_repo.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final UserRepo _userRepo;
  final WorkoutRepo _workoutRepo;

  WorkoutCubit({required UserRepo userRepo, required WorkoutRepo workoutRepo})
      : _userRepo = userRepo,
        _workoutRepo = workoutRepo,
        super(WorkoutInitial());

  Future<void> onFetchRecentWorkout() async {
    emit(WorkoutLoading());

    try {
      final userWorkout = _userRepo.recentWorkout();

      if (userWorkout != null) {
        final result = await _workoutRepo.getRecentWorkout(
          userId: userWorkout.userId!,
          workoutId: userWorkout.workoutId!,
        );

        emit(WorkoutLoaded(result));
      } else {
        emit(WorkoutNoData());
      }
    } catch (e) {
      emit(WorkoutError('Failed to fetch recent workout'));
    }
  }
}
