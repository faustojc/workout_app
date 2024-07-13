part of 'workout_cubit.dart';

sealed class WorkoutState {}

final class WorkoutInitial extends WorkoutState {}

final class WorkoutLoading extends WorkoutState {}

final class WorkoutLoaded<T> extends WorkoutState {
  final T data;

  WorkoutLoaded(this.data);
}

final class WorkoutNoData extends WorkoutState {}

final class WorkoutError extends WorkoutState {
  final String message;

  WorkoutError(this.message);
}
