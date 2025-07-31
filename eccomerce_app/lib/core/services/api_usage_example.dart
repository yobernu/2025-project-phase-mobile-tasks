import 'api_tester.dart';
import 'api_documentation.dart';

// Example of how to discover API parameters
class ApiUsageExample {
  
  // Run this to discover your API parameters
  static Future<void> discoverParameters() async {
    print('🚀 Starting API parameter discovery...\n');
    
    // Method 1: Test your specific API
    await ApiTester.testYourApi();
    
    // Method 2: Try common documentation endpoints
    await ApiDocumentation.discoverApiParameters();
    
    // Method 3: Check common parameter patterns
    print('📋 Common API Parameter Patterns:');
    print('Products: ${ApiParameters.productParams}');
    print('Users: ${ApiParameters.userParams}');
    print('Orders: ${ApiParameters.orderParams}');
  }
  
  // Example of how to use discovered parameters
  static Map<String, dynamic> createProductExample() {
    // Based on common patterns, here's what you might need:
    return {
      'name': 'Sample Product',
      'title': 'Product Title',
      'description': 'Product description',
      'price': 99.99,
      'category': 'electronics',
      'brand': 'Sample Brand',
      'sku': 'SKU123456',
      'stock': 100,
      'rating': 4.5,
      'images': ['image1.jpg', 'image2.jpg'],
      'tags': ['electronics', 'gadgets'],
      'sizes': ['S', 'M', 'L'],
      'colors': ['Red', 'Blue', 'Black'],
    };
  }
  
  // Example of how to handle API responses
  static void handleApiResponse(Map<String, dynamic> response) {
    print('📊 API Response Analysis:');
    
    // Generate parameter documentation from actual response
    final params = ApiTester.generateParamDocs(response);
    
    print('Discovered parameters:');
    params.forEach((key, description) {
      print('  $key: $description');
    });
  }
}

// Usage instructions:
/*
1. Replace 'https://your-api-endpoint.com' with your actual API URL
2. Run ApiUsageExample.discoverParameters() to test your API
3. Check the console output to see what parameters your API expects
4. Update your Product entity and repository based on the discovered parameters
5. Use the common patterns as a starting point if your API doesn't have documentation
*/ 