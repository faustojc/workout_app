part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class ScheduleNoData extends ScheduleState {
  final String message;

  ScheduleNoData({this.message = "No data available"});
}

final class ScheduleLoaded<T> extends ScheduleState {
  final T data;

  ScheduleLoaded(this.data);
}

final class ScheduleError extends ScheduleState {
  final String message;

  ScheduleError(this.message);
}
