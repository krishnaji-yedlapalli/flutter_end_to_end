

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sample_latest/core/data/db/offline_handler.dart';

class ConnectivityHandler {
  static final _singleton = ConnectivityHandler._internal();

  StreamSubscription<ConnectivityResult>? _subscription;

  StreamController<bool> connectionChangeStatusController = StreamController();

  final Connectivity _connectivity = Connectivity();

  ConnectivityHandler._internal();

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  factory ConnectivityHandler() {
    return _singleton;
  }

  dispose() {
    _subscription?.cancel();
    connectionChangeStatusController.close();
  }

  void initialize() async {

     assert(_subscription == null, 'Already connectivity handler initialized');

     if(await _connectivity.checkConnectivity() !=  ConnectivityResult.none){
       _isConnected = true;
     }
     _connectivityListener();
  }

  void _connectivityListener() {
     _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
       late bool currentState;
       if(result == ConnectivityResult.none){
          currentState = false;
        }else{
          currentState = true;
        }

       if(currentState != _isConnected) {
         _isConnected = currentState;
          connectionChangeStatusController.add(_isConnected);

          if(_isConnected) OfflineHandler().syncData();
        }
    });
  }
}
