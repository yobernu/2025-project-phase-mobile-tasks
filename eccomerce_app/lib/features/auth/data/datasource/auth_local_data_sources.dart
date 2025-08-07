import 'dart:convert';

import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalAuthDataSource {
  Future<void> cacheUser(User auth);
  Future<User?> getCachedUser();
  Future<void> clearUser();
}

class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  final SharedPreferences prefs;

  LocalAuthDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheUser(User user) async {
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  @override
  Future<User?> getCachedUser() async {
    final jsonString = prefs.getString('auth');
    if (jsonString != null) {
      return User.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove('auth');
  }
}
