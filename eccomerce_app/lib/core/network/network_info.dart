import 'package:internet_connection_checker/internet_connection_checker.dart';
abstract class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  NetworkInfoImpl({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}