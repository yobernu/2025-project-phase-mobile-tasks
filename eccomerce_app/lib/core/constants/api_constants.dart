class ApiConstants {
  // static const String apiKey = '688b1c1040c520e0888dd0be';
  // static const String baseUrl = 'https://fakestoreapi.com';
  static const String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2";

  // API endpoints
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer $token',
  };
}
