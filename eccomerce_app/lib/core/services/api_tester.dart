import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTester {
  static const String apiKey = '688b1c1040c520e0888dd0be';
  
  // Test your specific API endpoint
  static Future<void> testYourApi() async {
    print('🧪 Testing your API with key: $apiKey\n');
    
    // Replace with your actual API base URL
    const String baseUrl = 'https://your-api-endpoint.com';
    
    // Test different endpoints
    await _testGetRequest('$baseUrl/products', 'Products endpoint');
    await _testGetRequest('$baseUrl/categories', 'Categories endpoint');
    await _testGetRequest('$baseUrl/users', 'Users endpoint');
    
    // Test POST with sample data
    await _testPostRequest('$baseUrl/products', {
      'name': 'Test Product',
      'price': 99.99,
      'description': 'Test description',
    });
  }
  
  static Future<void> _testGetRequest(String url, String description) async {
    try {
      print('Testing GET: $description');
      print('URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
          'Authorization': 'Bearer $apiKey',
        },
      );
      
      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response structure:');
        _printJsonStructure(data, 0);
      } else {
        print('Error response: ${response.body}');
      }
      print('---\n');
      
    } catch (e) {
      print('Error: $e\n');
    }
  }
  
  static Future<void> _testPostRequest(String url, Map<String, dynamic> data) async {
    try {
      print('Testing POST: $url');
      print('Data: $data');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(data),
      );
      
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}\n');
      
    } catch (e) {
      print('Error: $e\n');
    }
  }
  
  static void _printJsonStructure(dynamic data, int indent) {
    final spaces = '  ' * indent;
    
    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map || value is List) {
          print('$spaces$key: ${value.runtimeType}');
          _printJsonStructure(value, indent + 1);
        } else {
          print('$spaces$key: ${value.runtimeType} = $value');
        }
      });
    } else if (data is List) {
      print('${spaces}List with ${data.length} items');
      if (data.isNotEmpty) {
        _printJsonStructure(data.first, indent + 1);
      }
    }
  }
  
  // Generate parameter documentation from API response
  static Map<String, String> generateParamDocs(Map<String, dynamic> apiResponse) {
    final Map<String, String> params = {};
    
    apiResponse.forEach((key, value) {
      final type = value.runtimeType.toString();
      params[key] = '$type - $key';
    });
    
    return params;
  }
} 