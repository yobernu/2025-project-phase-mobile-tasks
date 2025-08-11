// core/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences prefs;

  AuthService({required this.prefs});

  String? getToken() => prefs.getString('access_token');

  Future<void> saveToken(String token) async {
    await prefs.setString('access_token', token);
  }

  Future<void> clearToken() async {
    await prefs.remove('access_token');
  }

  bool isAuthenticated() => getToken() != null;
}
