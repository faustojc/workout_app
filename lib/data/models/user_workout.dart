import 'package:workout_routine/data/models/mixin/model.dart';

enum UserWorkoutStatus { incomplete, completed }

class UserWorkout extends Model<UserWorkout> {
  final String? id;
  final String? userId;
  final String? workoutId;
  final String? workoutCategoryId;
  final String? dayId;
  final UserWorkoutStatus status;
  final Duration? playedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserWorkout({
    this.id,
    this.userId,
    this.workoutId,
    this.workoutCategoryId,
    this.dayId,
    this.status = UserWorkoutStatus.incomplete,
    this.playedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserWorkout.fromJson(Map<String, dynamic> json) {
    UserWorkoutStatus status = UserWorkoutStatus.incomplete;
    Duration? playedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['status'] != null && json['status'] is String) {
      status = json['status'] == 'completed' ? UserWorkoutStatus.completed : UserWorkoutStatus.incomplete;
    }
    if (json['played_at'] != null && json['played_at'] is int) {
      playedAt = Duration(seconds: json['played_at']);
    }
    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return UserWorkout(
      id: json['id'],
      userId: json['user_id'],
      workoutId: json['workout_id'],
      workoutCategoryId: json['workout_category_id'],
      dayId: json['day_id'],
      status: status,
      playedAt: playedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  UserWorkout fromJson(Map<String, dynamic> json) => UserWorkout.fromJson(json);

  @override
  String get tableName => "user_workouts";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['status'] = status == UserWorkoutStatus.completed ? 'completed' : 'incomplete';

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (workoutId != null && workoutId!.isNotEmpty) data['workout_id'] = workoutId;
    if (workoutCategoryId != null && workoutCategoryId!.isNotEmpty) data['workout_category_id'] = workoutCategoryId;
    if (dayId != null && dayId!.isNotEmpty) data['day_id'] = dayId;

    // Duration fields
    if (playedAt != null) data['played_at'] = playedAt!.inSeconds;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
