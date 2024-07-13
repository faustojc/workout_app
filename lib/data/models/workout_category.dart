import 'package:workout_routine/data/models/mixin/model.dart';

class WorkoutCategory extends Model<WorkoutCategory> {
  final String? id;
  final String? daysId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutCategory({
    this.id,
    this.daysId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutCategory.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return WorkoutCategory(
      id: json['id'],
      daysId: json['days_id'],
      name: json['name'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  WorkoutCategory fromJson(Map<String, dynamic> json) => WorkoutCategory.fromJson(json);

  @override
  String get tableName => "workout_categories";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (daysId != null && daysId!.isNotEmpty) data['days_id'] = daysId;
    if (name != null && name!.isNotEmpty) data['name'] = name;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
