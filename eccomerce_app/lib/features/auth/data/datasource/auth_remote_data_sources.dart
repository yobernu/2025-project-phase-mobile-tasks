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
// TODO: This API server has been suspended. 
// You need to either:
// 1. Contact the API owner to restore the service
// 2. Use a different API endpoint
// 3. Set up your own backend server
// 4. Use a mock API for testing

// Alternative endpoints you could try:
// const _baseUrl = 'https://your-own-api.com/api/auth';
// const _baseUrl = 'https://jsonplaceholder.typicode.com/users'; // For testing

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final http.Client client;

  RemoteAuthDataSourceImpl({required this.client});

  @override
  Future<User> register(String name, String email, String password) async {
    // TODO: Replace with real API call when server is available
    // Mock implementation for testing
    print('Using mock API for testing...');
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    
    // Return mock user data
    final mockUserData = {
      'id': 1,
      'name': name,
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    print('Mock user created: $mockUserData');
    return User.fromJson(mockUserData);
    
    // Original API call (commented out due to suspended server)
    /*
    final url = Uri.parse('$_baseUrl/register');
    final body = jsonEncode({
      'name': name, 
      'email': email, 
      'password': password
    });
    
    print('Making API request to: $url');
    print('Request body: $body');
    print('Request headers: $headers');

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Parsed response data: $data');
        
        if (data['data'] != null) {
          return User.fromJson(data['data']);
        } else {
          print('No data field in response');
          throw ServerException();
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Exception during API call: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
    */
  }

  @override
  Future<User> login(String email, String password) async {
    // TODO: Replace with real API call when server is available
    // Mock implementation for testing
    print('Using mock login API for testing...');
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    
    // Return mock user data
    final mockUserData = {
      'id': 1,
      'name': 'Test User',
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    print('Mock user logged in: $mockUserData');
    return User.fromJson(mockUserData);
    
    // Original API call (commented out due to suspended server)
    /*
    final url = Uri.parse('$_baseUrl/login');
    final body = jsonEncode({
      'email': email, 
      'password': password
    });
    
    print('Making login API request to: $url');

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: body,
      );

      print('Login response status code: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Parsed login response data: $data');
        
        if (data['data'] != null) {
          return User.fromJson(data['data']);
        } else {
          print('No data field in login response');
          throw ServerException();
        }
      } else {
        print('Login API request failed with status: ${response.statusCode}');
        print('Login error response: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Exception during login API call: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
    */
  }

  @override
  Future<void> logout(int id) async {
    // TODO: Replace with real API call when server is available
    // Mock implementation for testing
    print('Using mock logout API for testing...');
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    
    print('Mock logout successful for user ID: $id');
    return;
    
    // Original API call (commented out due to suspended server)
    /*
    final url = Uri.parse('$_baseUrl/logout');
    final body = jsonEncode({'id': id});
    
    print('Making logout API request to: $url');

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: body,
      );

      print('Logout response status code: ${response.statusCode}');
      print('Logout response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Logout successful');
        return;
      } else {
        print('Logout API request failed with status: ${response.statusCode}');
        print('Logout error response: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Exception during logout API call: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
    */
  }
}
