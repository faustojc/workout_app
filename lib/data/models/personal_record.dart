import 'package:workout_routine/data/models/mixin/model.dart';

class PersonalRecord extends Model<PersonalRecord> {
  final String? id;
  final String? userId;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PersonalRecord({
    this.id,
    this.userId,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return PersonalRecord(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  PersonalRecord fromJson(Map<String, dynamic> json) => PersonalRecord.fromJson(json);

  @override
  String get tableName => "personal_records";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (title != null && title!.isNotEmpty) data['title'] = title;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
