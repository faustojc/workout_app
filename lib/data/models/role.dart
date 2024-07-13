import 'package:workout_routine/data/models/mixin/model.dart';

class Role extends Model<Role> {
  final String? id;
  final String? userId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role({
    this.id,
    this.userId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Role(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Role fromJson(Map<String, dynamic> json) => Role.fromJson(json);

  @override
  String get tableName => "roles";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (name != null && name!.isNotEmpty) data['name'] = name;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
