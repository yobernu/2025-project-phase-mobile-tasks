import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  NetworkInfoImpl({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected async {
    try {
      final result = await internetConnectionChecker.hasConnection;
      
      if (!result) {
        final response = await http.get(Uri.parse('https://www.google.com')).timeout(
          Duration(seconds: 5),
        );
        return response.statusCode == 200;
      }
      
      return result;
    } catch (e) {
      return false;
    }
  }
}