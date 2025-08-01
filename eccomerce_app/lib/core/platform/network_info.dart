import 'package:dartz/dartz.dart';

abstract class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected;
}