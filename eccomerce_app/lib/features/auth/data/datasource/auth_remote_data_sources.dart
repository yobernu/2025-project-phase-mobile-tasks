import 'dart:convert';
import 'dart:developer' as dev;
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
const _profileBaseUrl =
    'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2';

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

    dev.log('[LOGIN] Sending POST request to: $url');
    dev.log('[LOGIN] Request body: $body');

    try {
      final response = await client.post(url, headers: headers, body: body);

      dev.log('[LOGIN] Response status: ${response.statusCode}');
      dev.log('[LOGIN] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        // Safely extract token with proper null handling
        final tokenData = json['data'];
        if (tokenData == null) {
          dev.log('[LOGIN] No data field in response');
          throw ServerException('Invalid response format: missing data field');
        }

        final token = tokenData['access_token']?.toString();
        dev.log('[LOGIN] Extracted access token: $token');

        if (token == null || token.isEmpty) {
          dev.log('[LOGIN] Token not found or empty in response');
          throw ServerException(
            'Authentication failed: no access token received',
          );
        }

        // 🔄 Fetch full user profile using /users/me
        final profileUrl = Uri.parse('$_profileBaseUrl/users/me');
        final profileResponse = await client.get(
          profileUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        dev.log('[PROFILE] Response status: ${profileResponse.statusCode}');
        dev.log('[PROFILE] Response body: ${profileResponse.body}');

        if (profileResponse.statusCode == 200) {
          final profileJson = jsonDecode(profileResponse.body);
          final data = profileJson['data'];

          if (data == null) {
            dev.log('[PROFILE] No data field in profile response');
            throw ServerException(
              'Invalid profile response: missing data field',
            );
          }

          // Debug: Log the actual data structure
          dev.log('[PROFILE] Raw profile data: $data');
          dev.log('[PROFILE] Available keys: ${data.keys.toList()}');
          dev.log('[PROFILE] _id field: ${data['_id']}');
          dev.log('[PROFILE] id field: ${data['id']}');

          // Create user with proper null safety
          // Try both '_id' and 'id' fields as different APIs use different conventions
          final userId =
              data['_id']?.toString() ??
              data['id']?.toString() ??
              'unknown_user_${DateTime.now().millisecondsSinceEpoch}';

          final user = User(
            id: userId,
            name: data['name']?.toString() ?? '',
            email: data['email']?.toString() ?? '',
            role: data['role']?.toString(),
            accessToken: token,
          );

          dev.log('[LOGIN] Final User object: $user');
          return user;
        } else {
          dev.log(
            '[PROFILE] Failed to fetch user profile: ${profileResponse.statusCode}',
          );
          final errorBody = profileResponse.body.isNotEmpty
              ? profileResponse.body
              : 'Unknown error';
          throw ServerException('Failed to fetch user profile: $errorBody');
        }
      } else {
        dev.log('[LOGIN] Server returned error status: ${response.statusCode}');
        final errorBody = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {};
        final message = errorBody['message']?.toString() ?? 'Login failed';
        throw ServerException(message);
      }
    } catch (e, stackTrace) {
      dev.log('[LOGIN] Exception caught: $e');
      dev.log('[LOGIN] Stack trace: $stackTrace');

      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException('Network error: ${e.toString()}');
      }
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
