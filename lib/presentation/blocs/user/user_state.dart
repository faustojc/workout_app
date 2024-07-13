part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserDataLoaded<T> extends UserState {
  final T data;

  UserDataLoaded(this.data);
}

final class UserNoData extends UserState {}

final class UserSuccess extends UserState {
  final String message;

  UserSuccess({this.message = ''});
}

final class UserError extends UserState {
  final String message;

  UserError(this.message);
}
