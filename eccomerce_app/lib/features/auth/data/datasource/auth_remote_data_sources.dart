import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:http/http.dart' as http;

abstract class RemoteAuthDataSource {
  Future<User> register(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout(int id);
}

const _baseUrl = 'https://api.escuelajs.co/api/v1/auth';

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final http.Client client;

  RemoteAuthDataSourceImpl({required this.client});

  @override
  Future<User> register(String name, String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    final body = jsonEncode({
      'name': name, 
      'email': email, 
      'password': password
    });

    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      if (data['data'] != null) {
        return User.fromJson(data['data']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = jsonEncode({
      'email': email, 
      'password': password
    });

    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      if (data['data'] != null) {
        return User.fromJson(data['data']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout(int id) async {
    final url = Uri.parse('$_baseUrl/logout');
    final body = jsonEncode({'id': id});

    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw ServerException();
    }
  }
}
