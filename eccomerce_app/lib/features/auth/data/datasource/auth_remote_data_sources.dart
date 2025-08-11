import 'dart:convert';
import 'dart:developer' as dev;
import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:http/http.dart' as http;

abstract class RemoteAuthDataSource {
  Future<User> register(String name, String email, String password);
  Future<User> login(String email, String password);
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final http.Client client;
  final AuthService authService;

  RemoteAuthDataSourceImpl({required this.client, required this.authService});

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<User> register(String name, String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/register');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      final response = await client.post(url, headers: headers, body: body);

      dev.log('[REGISTER] Response status: ${response.statusCode}');
      dev.log('[REGISTER] Response body: ${response.body}');

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
      dev.log('[REGISTER] Exception: $e');
      dev.log('[REGISTER] Stack trace: $stack');
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
    final body = jsonEncode({'email': email, 'password': password});

    dev.log('[LOGIN] Sending POST request to: $url');
    dev.log('[LOGIN] Request body: $body');

    try {
      final response = await client.post(url, headers: headers, body: body);

      dev.log('[LOGIN] Response status: ${response.statusCode}');
      dev.log('[LOGIN] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final tokenData = json['data'];

        if (tokenData == null) {
          throw ServerException('Invalid response format: missing data field');
        }

        final token = tokenData['access_token']?.toString();
        if (token == null || token.isEmpty) {
          throw ServerException(
            'Authentication failed: no access token received',
          );
        }

        // ✅ Save token using AuthService
        await authService.saveToken(token);
        dev.log('[LOGIN] Token saved to AuthService');

        // 🔄 Fetch user profile
        final profileUrl = Uri.parse('${ApiConstants.baseUrl}/users/me');
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
            throw ServerException(
              'Invalid profile response: missing data field',
            );
          }

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
          final errorBody = profileResponse.body.isNotEmpty
              ? profileResponse.body
              : 'Unknown error';
          throw ServerException('Failed to fetch user profile: $errorBody');
        }
      } else {
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
}
