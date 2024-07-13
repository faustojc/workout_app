import 'package:workout_routine/data/models/workout.dart';
import 'package:workout_routine/data/models/workout_parameter.dart';

class RecentWorkoutDetails {
  final Workout workout;
  final Duration playedAt;
  final List<WorkoutParameter> parameters;

  RecentWorkoutDetails({
    required this.workout,
    required this.playedAt,
    required this.parameters,
  });
}
