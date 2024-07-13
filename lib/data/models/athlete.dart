import 'package:workout_routine/data/models/mixin/model.dart';

class Athlete extends Model<Athlete> {
  final String? id;
  final String? userId;
  final String? categoryId;
  final String? firstname;
  final String? lastname;
  final String? sex;
  final int? age;
  final num? height;
  final num? weight;
  final String? city;
  final String? address;
  final DateTime? birthday;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Athlete({
    this.id,
    this.userId,
    this.categoryId,
    this.firstname,
    this.lastname,
    this.sex,
    this.age,
    this.height,
    this.weight,
    this.city,
    this.address,
    this.birthday,
    this.createdAt,
    this.updatedAt,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    DateTime? birthday;
    DateTime? createdAt;
    DateTime? updatedAt;

    if (json['birthday'] != null && json['birthday'] is String) {
      birthday = DateTime.parse(json['birthday']);
    }
    if (json['created_at'] != null && json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null && json['updated_at'] is String) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    return Athlete(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      sex: json['sex'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      city: json['city'],
      address: json['address'],
      birthday: birthday,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Athlete fromJson(Map<String, dynamic> json) => Athlete.fromJson(json);

  @override
  String get tableName => "athletes";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['userId'] = userId;
    if (categoryId != null && categoryId!.isNotEmpty) data['categoryId'] = categoryId;
    if (firstname != null && firstname!.isNotEmpty) data['firstname'] = firstname;
    if (lastname != null && lastname!.isNotEmpty) data['lastname'] = lastname;
    if (sex != null && sex!.isNotEmpty) data['sex'] = sex;
    if (city != null && city!.isNotEmpty) data['city'] = city;
    if (address != null && address!.isNotEmpty) data['address'] = address;

    // Numerical fields
    if (age != null) data['age'] = age;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;

    // DateTime fields
    if (birthday != null) data['birthday'] = birthday!.toIso8601String();
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }
}
