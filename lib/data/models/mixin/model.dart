import 'package:workout_routine/data/models/mixin/query_builder.dart';

abstract class Model<T> {
  Map<String, dynamic> toJson();

  String get tableName;

  T fromJson(Map<String, dynamic> json);

  /// Returns a QueryBuilder instance with the table name set to the current model's table name
  QueryBuilder get query => QueryBuilder().from(tableName);
}
