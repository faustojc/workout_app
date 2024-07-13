import 'package:logger/logger.dart';
import 'package:workout_routine/data/models/athlete.dart';
import 'package:workout_routine/data/models/notification.dart';
import 'package:workout_routine/data/models/personal_record.dart';
import 'package:workout_routine/data/models/personal_records_history.dart';
import 'package:workout_routine/data/models/role.dart';
import 'package:workout_routine/data/models/subscription.dart';
import 'package:workout_routine/data/models/user_workout.dart';
import 'package:workout_routine/data/sources/database.dart';

class UserRepo {
  Athlete athlete = Athlete();
  Subscription subscription = Subscription();
  Role role = Role();

  final List<Notification> notifications = [];
  final List<UserWorkout> userWorkouts = [];
  final List<PersonalRecord> records = [];
  final List<PersonalRecordsHistory> histories = [];

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 8,
      errorMethodCount: 12,
      printTime: true,
    ),
  );

  Future<void> fetchData({required String userId}) async {
    try {
      final List<Future<dynamic>> futures = [
        Athlete().query.where('user_id', '=', userId).get(),
        Subscription().query.where('user_id', '=', userId).get(),
        Notification().query.where('user_id', '=', userId).limit(10).getAll(),
        UserWorkout().query.where('user_id', '=', userId).limit(10).getAll(),
        PersonalRecord().query.where('user_id', '=', userId).limit(10).getAll(),
        PersonalRecordsHistory().query.where('user_id', '=', userId).limit(10).getAll(),
      ];

      final results = await Future.wait(futures);

      athlete = Athlete.fromJson(results[0] as Map<String, dynamic>);
      subscription = Subscription.fromJson(results[1] as Map<String, dynamic>);
      notifications.addAll((results[2] as List).map((e) => Notification.fromJson(e)).toList());
      userWorkouts.addAll((results[3] as List).map((e) => UserWorkout.fromJson(e)).toList());
      records.addAll((results[4] as List).map((e) => PersonalRecord.fromJson(e)).toList());
      histories.addAll((results[5] as List).map((e) => PersonalRecordsHistory.fromJson(e)).toList());
    } catch (err) {
      logger.e(err.toString());
      rethrow;
    }
  }

  Future<void> createUser({required String userId, required Map<String, dynamic> data}) async {
    role = Role.fromJson({'user_id': userId, 'role': 'user'});
    subscription = Subscription.fromJson({'user_id': userId});
    athlete = Athlete.fromJson({'user_id': userId, ...data});

    try {
      final results = await Database.instance.powersyncDb.writeTransaction((txn) async {
        final athleteQuery = athlete.query.insert(athlete.toJson()).toSql();
        final subscriptionQuery = subscription.query.insert(subscription.toJson()).toSql();
        final roleQuery = role.query.insert(role.toJson()).toSql();

        await txn.execute(athleteQuery);
        await txn.execute(subscriptionQuery);
        await txn.execute(roleQuery);

        return txn;
      });

      logger.i('User created successfully: ${results.toString()}');
    } catch (err) {
      logger.e(err.toString());
      rethrow;
    }
  }

  UserWorkout? recentWorkout() {
    if (userWorkouts.isEmpty) {
      return null;
    }

    if (userWorkouts.length == 1) {
      return userWorkouts.first;
    }

    return userWorkouts.reduce((a, b) => a.updatedAt!.isAfter(b.updatedAt!) ? a : b);
  }
}
