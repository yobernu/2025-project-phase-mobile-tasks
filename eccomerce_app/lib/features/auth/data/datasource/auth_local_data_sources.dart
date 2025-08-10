import 'dart:convert';

import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalAuthDataSource {
  Future<void> cacheUser(User auth);
  Future<User?> getCachedUser();
  Future<void> clearUser();
   Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveAccessToken(String token);

  
}

class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  final SharedPreferences prefs;

  LocalAuthDataSourceImpl({required this.prefs});

  static const _userKey = 'user';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<void> cacheUser(User user) async {
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_accessTokenKey, user.accessToken.toString());
    await prefs.setString(_refreshTokenKey, user.accessToken.toString());
  }

  @override
  Future<User?> getCachedUser() async {
    final jsonString = prefs.getString(_userKey);
    if (jsonString != null) {
      return User.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(_userKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  @override
  Future<String?> getAccessToken() async {
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await prefs.setString(_accessTokenKey, token);
  }
}