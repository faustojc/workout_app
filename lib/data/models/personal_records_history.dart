import 'package:workout_routine/data/models/mixin/model.dart';

class PersonalRecordsHistory extends Model<PersonalRecordsHistory> {
  final String? id;
  final String? userId;
  final String? recordsId;
  final num? weight;
  final DateTime? createdAt;

  PersonalRecordsHistory({
    this.id,
    this.userId,
    this.recordsId,
    this.weight,
    this.createdAt,
  });

  factory PersonalRecordsHistory.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }

    return PersonalRecordsHistory(
      id: json['id'],
      userId: json['user_id'],
      recordsId: json['records_id'],
      weight: json['weight'],
      createdAt: createdAt,
    );
  }

  @override
  PersonalRecordsHistory fromJson(Map<String, dynamic> json) => PersonalRecordsHistory.fromJson(json);

  @override
  String get tableName => "personal_records_history";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (recordsId != null && recordsId!.isNotEmpty) data['records_id'] = recordsId;

    // num fields
    if (weight != null) data['weight'] = weight;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();

    return data;
  }
}
