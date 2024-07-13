import 'package:workout_routine/data/models/mixin/model.dart';

class Notification extends Model<Notification> {
  final String? id;
  final String? userId;
  final String? message;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notification({
    this.id,
    this.userId,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Notification(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Notification fromJson(Map<String, dynamic> json) => Notification.fromJson(json);

  @override
  String get tableName => "notifications";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (message != null && message!.isNotEmpty) data['message'] = message;
    if (isRead != null) data['is_read'] = isRead;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
