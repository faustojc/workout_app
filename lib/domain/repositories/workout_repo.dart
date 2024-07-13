import 'package:logger/logger.dart';
import 'package:workout_routine/data/models/mixin/query_builder.dart';
import 'package:workout_routine/data/models/workout.dart';
import 'package:workout_routine/data/models/workout_category.dart';
import 'package:workout_routine/data/models/workout_parameter.dart';
import 'package:workout_routine/data/modules/recent_workout_details.dart';

class WorkoutRepo {
  final List<WorkoutCategory> workoutCategories = [];
  final List<WorkoutParameter> parameters = [];
  final List<Workout> workouts = [];

  late Workout currWorkout = Workout();

  // Log
  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 4,
    printEmojis: false,
    printTime: true,
  ));

  Future<void> fetchWorkoutData(String categoryId) async {
    try {
      final workoutResult = await Workout()
          .query //
          .where('category_id', '=', categoryId)
          .getAll()
          .then((e) => e.map((e) => Workout.fromJson(e)));

      workouts.addAll(workoutResult);

      // Query string for getting all the workout_parameter where the workout_id is in the list of workout ids
      final parametersResult = await WorkoutParameter()
          .query //
          .whereIn('workout_id', workouts.map((e) => e.id).toList())
          .getAll()
          .then((e) => e.map((e) => WorkoutParameter.fromJson(e)));

      parameters.addAll(parametersResult);
    } catch (err) {
      logger.e(err.toString());
    }
  }

  Future<void> fetchWorkoutCategoryData(String periodizationId) async {
    try {
      workoutCategories.clear();

      final columns = {
        'workout_category.id AS category_id',
        'workout_category.days_id AS category_days_id',
        'workout_category.name AS category_name',
      };

      final results = await QueryBuilder() //
          .select(columns: columns)
          .from('workout_category')
          .join('days', 'workout_category.days_id = days.id')
          .join('weeks', 'days.weeks_id = weeks.id')
          .where('weeks.periodization_id', '=', periodizationId)
          .getAll();

      workoutCategories.addAll(results
          .map((result) => WorkoutCategory.fromJson({
                'id': result['category_id'],
                'days_id': result['category_days_id'],
                'name': result['category_name'],
              }))
          .toList());
    } catch (err) {
      logger.e(err.toString());
    }
  }

  Future<void> fetchWorkoutsFromPeriodization(String periodizationId) async {
    try {
      workouts.clear();

      final result = await QueryBuilder() //
          .select()
          .from('workouts')
          .join('workout_category', 'workouts.category_id = workout_category.id')
          .join('days', 'workout_category.days_id = days.id')
          .join('weeks', 'days.weeks_id = weeks.id')
          .where('weeks.periodization_id', '=', periodizationId)
          .getAll();

      workouts.addAll(result.map((e) => Workout.fromJson(e)).toList());
    } catch (err) {
      logger.e(err.toString());
    }
  }

  Future<RecentWorkoutDetails> getRecentWorkout({required String userId, required String workoutId}) async {
    final Set<String> columns = {
      'user_workouts.played_at AS played_at',
      'workouts.title AS title',
      'workouts.video_duration AS video_duration',
      'workouts.thumbnail_url AS thumbnail_url',
      'workout_parameters.value AS parameters',
    };

    final result = await QueryBuilder() //
        .select(columns: columns)
        .from('user_workouts')
        .join('workouts', 'user_workouts.workout_id = workouts.id')
        .join('workout_parameters', 'workout_parameters.workout_id = workouts.id')
        .where('user_workouts.user_id', '=', userId)
        .where('user_workouts.workout_id', '=', workoutId)
        .get();

    return RecentWorkoutDetails(
      workout: Workout.fromJson({
        'title': result['title'],
        'video_duration': result['video_duration'],
        'thumbnail_url': result['thumbnail_url'],
      }),
      playedAt: result['played_at'],
      parameters: result['parameters'],
    );
  }

  Future<void> getWorkoutParameters({required String workoutId}) async {
    final result = await WorkoutParameter()
        .query //
        .where('workout_id', '=', workoutId)
        .getAll()
        .then((e) => e.map((e) => WorkoutParameter.fromJson(e)));

    parameters.addAll(result);
  }
}
