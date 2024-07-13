import 'package:workout_routine/data/models/mixin/model.dart';

class Workout extends Model<Workout> {
  final String? id;
  final String? categoryId;
  final String? title;
  final String? description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final Duration? videoDuration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Workout({
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
    this.videoDuration,
    this.createdAt,
    this.updatedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    Duration? videoDuration;
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['video_duration'] != null && json['video_duration'] is String) {
      final parsedDateTime = DateTime.parse(json['video_duration']);

      videoDuration = parsedDateTime.difference(DateTime.utc(DateTime.now().year));
    }
    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Workout(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      videoDuration: videoDuration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Workout fromJson(Map<String, dynamic> json) => Workout.fromJson(json);

  @override
  String get tableName => "workouts";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (categoryId != null && categoryId!.isNotEmpty) data['category_id'] = categoryId;
    if (title != null && title!.isNotEmpty) data['title'] = title;
    if (description != null && description!.isNotEmpty) data['description'] = description;
    if (videoUrl != null && videoUrl!.isNotEmpty) data['video_url'] = videoUrl;
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) data['thumbnail_url'] = thumbnailUrl;

    if (videoDuration != null) {
      final dateTimeForDuration = DateTime.utc(DateTime.now().year).add(videoDuration!);

      data['video_duration'] = dateTimeForDuration.toIso8601String();
    }

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
