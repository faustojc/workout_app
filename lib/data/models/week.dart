import 'package:workout_routine/data/models/mixin/model.dart';

class Week extends Model<Week> {
  final String? id;
  final String? periodizationId;
  final String? title;
  final String? subtitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Week({
    this.id,
    this.periodizationId,
    this.title,
    this.subtitle,
    this.createdAt,
    this.updatedAt,
  });

  factory Week.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Week(
      id: json['id'],
      periodizationId: json['periodization_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Week fromJson(Map<String, dynamic> json) => Week.fromJson(json);

  @override
  String get tableName => "weeks";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (periodizationId != null && periodizationId!.isNotEmpty) data['periodization_id'] = periodizationId;
    if (title != null && title!.isNotEmpty) data['title'] = title;
    if (subtitle != null && subtitle!.isNotEmpty) data['subtitle'] = subtitle;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
