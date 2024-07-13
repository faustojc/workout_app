import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/data/models/personal_records_history.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;

  UserCubit({required this.userRepo}) : super(UserInitial());

  void onFetchRecentRecords() {
    emit(UserLoading());

    if (userRepo.records.isEmpty) {
      emit(UserNoData());
    } else {
      userRepo.records.take(4).toList().sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      emit(UserDataLoaded(userRepo.records));
    }
  }

  Future<void> onFetchData({required String userId}) async {
    emit(UserLoading());

    try {
      await userRepo.fetchData(userId: userId);
      emit(UserSuccess());
    } catch (e) {
      emit(UserError('Failed to fetch data'));
    }
  }

  Future<void> onCreateUser({required String userId, required Map<String, dynamic> data}) async {
    emit(UserLoading());

    try {
      await userRepo.createUser(userId: userId, data: data);
      emit(UserSuccess());
    } catch (e) {
      emit(UserError('Failed to create user data'));
    }
  }

  PersonalRecordsHistory? getHistoryRecord(String id) {
    if (userRepo.histories.isEmpty) {
      return null;
    }

    if (userRepo.histories.length == 1) {
      return userRepo.histories.first;
    }

    return userRepo.histories //
        .where((history) => history.recordsId == id)
        .reduce((a, b) => a.createdAt!.isAfter(b.createdAt!) ? a : b);
  }
}
