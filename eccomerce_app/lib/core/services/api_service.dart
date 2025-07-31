import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  final http.Client _client = http.Client();

  // GET request with API key
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: ApiConstants.headers,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // POST request with API key
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: ApiConstants.headers,
      body: json.encode(data),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  }

  // PUT request with API key
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: ApiConstants.headers,
      body: json.encode(data),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  // DELETE request with API key
  Future<void> delete(String endpoint) async {
    final response = await _client.delete(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: ApiConstants.headers,
    );
    
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }
} 