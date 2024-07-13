import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'connection_event.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, InternetStatus> {
  late StreamSubscription<List<ConnectivityResult>> _result;
  late StreamSubscription<InternetStatus> _internetListener;

  ConnectionBloc() : super(InternetStatus.disconnected) {
    _result = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    on<ConnectionCheck>((event, emit) {
      emit(state);
    }, transformer: concurrent());

    on<ConnectionConnected>((event, emit) {
      emit(InternetStatus.connected);
    });

    on<ConnectionDisconnected>((event, emit) {
      emit(InternetStatus.disconnected);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
      _internetListener = InternetConnection().onStatusChange.listen((status) {
        if (status == InternetStatus.connected) {
          add(ConnectionConnected());
        } else {
          add(ConnectionDisconnected());
        }
      });
    } else {
      add(ConnectionDisconnected());
    }
  }

  @override
  Future<void> close() {
    _result.cancel();
    _internetListener.cancel();

    return super.close();
  }
}
