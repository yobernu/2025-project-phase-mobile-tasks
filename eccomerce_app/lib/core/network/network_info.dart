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
      // Try the original method first
      final result = await internetConnectionChecker.hasConnection;
      print('InternetConnectionChecker result: $result');
      
      // If that fails, try a simple HTTP request
      if (!result) {
        print('Trying HTTP fallback...');
        final response = await http.get(Uri.parse('https://www.google.com')).timeout(
          Duration(seconds: 5),
        );
        print('HTTP fallback result: ${response.statusCode}');
        return response.statusCode == 200;
      }
      
      return result;
    } catch (e) {
      print('Network check error: $e');
      return false;
    }
  }
}