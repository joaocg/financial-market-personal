import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

enum ConnectivityStatus { online, offline }

class ConnectivityEvent {}

class _ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityResult result;
  _ConnectivityChanged(this.result);
}

class ConnectivityState {
  final ConnectivityStatus status;
  ConnectivityState(this.status);
}

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  ConnectivityBloc() : super(ConnectivityState(ConnectivityStatus.online)) {
    on<_ConnectivityChanged>((event, emit) {
      if (event.result == ConnectivityResult.none) {
        emit(ConnectivityState(ConnectivityStatus.offline));
      } else {
        emit(ConnectivityState(ConnectivityStatus.online));
      }
    });

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      add(_ConnectivityChanged(result));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
