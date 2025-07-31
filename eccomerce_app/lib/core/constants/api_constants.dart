class ApiConstants {
  static const String apiKey = '688b1c1040c520e0888dd0be';
  static const String baseUrl = 'https://your-api-endpoint.com';
  
  // API endpoints
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
    'X-API-Key': apiKey,
  };
} 