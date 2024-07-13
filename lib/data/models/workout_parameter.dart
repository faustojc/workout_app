import 'package:workout_routine/data/models/mixin/model.dart';

class WorkoutParameter extends Model<WorkoutParameter> {
  final String? id;
  final String? workoutId;
  final String? name;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutParameter({
    this.id,
    this.workoutId,
    this.name,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutParameter.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return WorkoutParameter(
      id: json['id'],
      workoutId: json['workout_id'],
      name: json['name'],
      value: json['value'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  WorkoutParameter fromJson(Map<String, dynamic> json) => WorkoutParameter.fromJson(json);

  @override
  String get tableName => "workout_parameters";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (workoutId != null && workoutId!.isNotEmpty) data['workout_id'] = workoutId;
    if (name != null && name!.isNotEmpty) data['name'] = name;
    if (value != null && value!.isNotEmpty) data['value'] = value;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
