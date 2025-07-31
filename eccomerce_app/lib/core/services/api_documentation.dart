import 'package:http/http.dart' as http;

class ApiDocumentation {
  static const String apiKey = '688b1c1040c520e0888dd0be';
  
  // Test different API endpoints to discover parameters
  static Future<void> discoverApiParameters() async {
    print('🔍 Discovering API parameters...\n');
    
    // Test 1: Try to get API documentation
    await _testEndpoint('/docs');
    await _testEndpoint('/swagger');
    await _testEndpoint('/api-docs');
    
    // Test 2: Try common product endpoints
    await _testEndpoint('/products');
    await _testEndpoint('/api/products');
    
    // Test 3: Try with different authentication methods
    await _testWithDifferentAuth();
  }
  
  static Future<void> _testEndpoint(String endpoint) async {
    try {
      print('Testing endpoint: $endpoint');
      
      // Test with API key in header
      final response1 = await http.get(
        Uri.parse('https://your-api-endpoint.com$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
        },
      );
      
      print('Status: ${response1.statusCode}');
      if (response1.statusCode == 200) {
        print('Response: ${response1.body.substring(0, 200)}...');
      }
      
      // Test with Bearer token
      final response2 = await http.get(
        Uri.parse('https://your-api-endpoint.com$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      );
      
      print('Bearer Status: ${response2.statusCode}\n');
      
    } catch (e) {
      print('Error testing $endpoint: $e\n');
    }
  }
  
  static Future<void> _testWithDifferentAuth() async {
    print('Testing different authentication methods...');
    
    // Test as query parameter
    try {
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/products?api_key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Query param status: ${response.statusCode}');
    } catch (e) {
      print('Query param error: $e');
    }
  }
}

// Common API parameter patterns
class ApiParameters {
  // Product parameters (common patterns)
  static const Map<String, String> productParams = {
    'id': 'int - Product unique identifier',
    'name': 'string - Product name',
    'title': 'string - Product title',
    'description': 'string - Product description',
    'price': 'number - Product price',
    'image': 'string - Product image URL',
    'category': 'string - Product category',
    'brand': 'string - Product brand',
    'sku': 'string - Stock keeping unit',
    'stock': 'int - Available quantity',
    'rating': 'number - Product rating (0-5)',
    'reviews': 'array - Product reviews',
    'tags': 'array - Product tags',
    'sizes': 'array - Available sizes',
    'colors': 'array - Available colors',
    'created_at': 'datetime - Creation timestamp',
    'updated_at': 'datetime - Last update timestamp',
  };
  
  // User parameters
  static const Map<String, String> userParams = {
    'id': 'int - User unique identifier',
    'email': 'string - User email',
    'name': 'string - User full name',
    'username': 'string - Username',
    'phone': 'string - Phone number',
    'address': 'object - User address',
    'created_at': 'datetime - Account creation date',
  };
  
  // Order parameters
  static const Map<String, String> orderParams = {
    'id': 'int - Order unique identifier',
    'user_id': 'int - User who placed order',
    'products': 'array - Ordered products',
    'total': 'number - Order total amount',
    'status': 'string - Order status',
    'shipping_address': 'object - Shipping address',
    'payment_method': 'string - Payment method used',
    'created_at': 'datetime - Order creation date',
  };
} 