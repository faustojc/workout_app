part of 'connection_bloc.dart';

@immutable
sealed class ConnectionEvent {}

final class ConnectionCheck extends ConnectionEvent {}

final class ConnectionConnected extends ConnectionEvent {}

final class ConnectionDisconnected extends ConnectionEvent {}
