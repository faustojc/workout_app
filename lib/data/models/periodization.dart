import 'package:workout_routine/data/models/mixin/model.dart';

class Periodization extends Model<Periodization> {
  final String? id;
  final String? name;
  final String? acronym;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Periodization({
    this.id,
    this.name,
    this.acronym,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Periodization.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Periodization(
      id: json['id'],
      name: json['name'],
      acronym: json['acronym'],
      description: json['description'],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Periodization fromJson(Map<String, dynamic> json) => Periodization.fromJson(json);

  @override
  String get tableName => "periodizations";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (name != null && name!.isNotEmpty) data['name'] = name;
    if (acronym != null && acronym!.isNotEmpty) data['acronym'] = acronym;
    if (description != null && description!.isNotEmpty) data['description'] = description;

    // DateTime fields
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }
}
