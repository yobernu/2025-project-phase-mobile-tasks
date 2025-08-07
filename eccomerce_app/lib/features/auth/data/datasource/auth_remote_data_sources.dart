import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:http/http.dart' as http;

abstract class RemoteAuthDataSource {
  Future<User> register(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout(int id);
}

const _baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v2/auth';

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final http.Client client;

  RemoteAuthDataSourceImpl({required this.client});

  @override
  Future<User> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<User> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout(int id) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  // login and logout would follow a similar pattern
}
