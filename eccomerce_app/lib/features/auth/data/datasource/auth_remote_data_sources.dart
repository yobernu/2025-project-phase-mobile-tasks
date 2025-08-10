import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:http/http.dart' as http;

abstract class RemoteAuthDataSource {
  Future<User> register(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout(String id);
  Future<String> refreshToken(String refreshToken);
}

const _baseUrl =
    'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2/auth';

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
      'password': password,
    });

    try {
      final response = await client.post(url, headers: headers, body: body);
      //     if (response.statusCode == 503) {
      //   throw ServerException('Service is currently unavailable. Please try again later.');
      // }

      print('SignUp response status: ${response.statusCode}');
      print('SignUp response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['data'] != null) {
          return User.fromJson(data['data']);
        } else {
          throw ServerException('Missing user data in response');
        }
      } else {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unexpected server error';
        throw ServerException(message);
      }
    } catch (e, stack) {
      if (e is ServerException) {
        rethrow;
      } else {
        print('Unexpected error in register: $e');
        print('Stack trace: $stack');
        throw ServerException('Unexpected error: ${e.toString()}');
      }
    }
  }

@override
Future<User> login(String email, String password) async {
  final url = Uri.parse('$_baseUrl/login');
  final body = jsonEncode({'email': email, 'password': password});

  final response = await client.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    final json = jsonDecode(response.body);
    final token = json['data']?['access_token'];

    if (token != null) {
      return User(
        id: '0', // placeholder until you fetch full profile
        name: '',
        email: email,
        role: null,
        accessToken: token,
      );
    } else {
      throw ServerException();
    }
  } else {
    throw ServerException();
  }
}




  @override
  Future<void> logout(String id) async {
    final url = Uri.parse('$_baseUrl/logout');
    final body = jsonEncode({'id': id});

    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access_token'];
      if (newAccessToken != null && newAccessToken is String) {
        return newAccessToken;
      } else {
        throw Exception('Invalid token format');
      }
    } else {
      throw Exception('Failed to refresh token: ${response.statusCode}');
    }
  }
}
