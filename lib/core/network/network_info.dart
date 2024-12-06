import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maranata_mobile_app/main.dart';

// For checking internet connectivity
abstract class NetworkInfoI {
  Future<bool> isConnected();

  Future<ConnectivityResult> get connectivityResult;

  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  final Connectivity connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity);

  // Checks if the internet is connected or not
  // Returns [true] if internet is connected
  // Else it will return [false]
  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // To check the type of internet connectivity
  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await connectivity.checkConnectivity();
    return results.first; // Ou aplique a lógica necessária
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      connectivity.onConnectivityChanged.map((results) => results.first);
}

// Abstract class for failures
abstract class Failure {}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// Exceptions
class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

// Can be used for throwing [NoInternetException]
class NoInternetException implements Exception {
  late final String _message;

  NoInternetException([String message = 'No Internet Exception Occurred']) {
    if (globalMessengerKey.currentState != null) {
      globalMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(message)));
    }
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
