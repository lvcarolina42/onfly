import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkConnectivityStatus {
  wifi,
  mobile,
  none;

  bool get isOnline => this != none;
}

class NetworkConnectivityRepository {
  NetworkConnectivityRepository();
  static final _instance = NetworkConnectivityRepository();
  static NetworkConnectivityRepository get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();

  NetworkConnectivityStatus networkConnectivityStatus = NetworkConnectivityStatus.none;

  Stream<NetworkConnectivityStatus> get connectivityStream => _controller.stream.map((source) {
    if (source.values.first) {
      switch (source.keys.first) {
        case ConnectivityResult.mobile:
          networkConnectivityStatus = NetworkConnectivityStatus.mobile;
          break;
        case ConnectivityResult.wifi:
          networkConnectivityStatus = NetworkConnectivityStatus.wifi;
          break;
        default:
          networkConnectivityStatus = NetworkConnectivityStatus.none;
      }
    } else {
      networkConnectivityStatus = NetworkConnectivityStatus.none;
    }
    return networkConnectivityStatus;
  });

  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});

  }
  void disposeStream() => _controller.close();
}
