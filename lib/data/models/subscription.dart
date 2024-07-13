import 'package:workout_routine/data/models/mixin/model.dart';

class Subscription extends Model<Subscription> {
  final String? id;
  final String? userId;
  final String? paymentMethod;
  final num? price;
  final DateTime? dateSubscribed;
  final DateTime? dateExpired;

  Subscription({
    this.id,
    this.userId,
    this.paymentMethod,
    this.price,
    this.dateSubscribed,
    this.dateExpired,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    DateTime? dateSubscribed;
    DateTime? dateExpired;

    if (json['date_subscribed'] != null && json['date_subscribed'] is String) {
      dateSubscribed = DateTime.parse(json['date_subscribed']);
    }
    if (json['date_expired'] != null && json['date_expired'] is String) {
      dateExpired = DateTime.parse(json['date_expired']);
    }

    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      paymentMethod: json['payment_method'],
      price: json['price'],
      dateSubscribed: dateSubscribed,
      dateExpired: dateExpired,
    );
  }

  @override
  Subscription fromJson(Map<String, dynamic> json) => Subscription.fromJson(json);

  @override
  String get tableName => "subscriptions";

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // String fields
    if (id != null && id!.isNotEmpty) data['id'] = id;
    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (paymentMethod != null && paymentMethod!.isNotEmpty) data['payment_method'] = paymentMethod;

    // number fields
    if (price != null) data['price'] = price;

    // DateTime fields
    if (dateSubscribed != null) data['date_subscribed'] = dateSubscribed!.toIso8601String();
    if (dateExpired != null) data['date_expired'] = dateExpired!.toIso8601String();

    return data;
  }
}
