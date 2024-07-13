import 'package:workout_routine/data/models/mixin/model.dart';

class Category extends Model<Category> {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json['created_at'] != null && json['created_at'] is String) {
      json['created_at'] = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      json['updated_at'] = DateTime.parse(json['updated_at']);
    }

    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  Category fromJson(Map<String, dynamic> json) => Category.fromJson(json);

  @override
  String get tableName => "category";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (name != null && name!.isNotEmpty) data['name'] = name;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
