import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import '../fixtures/fixture_reader.dart';

class TestHelpers {
  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1';
  static const Map<String, String> headers = {'Content-Type': 'application/json'};

  static ProductModel createTestProduct({
    int id = 1,
    String title = 'Test Product',
    String price = '100',
    String description = 'Test Description',
    String imagePath = 'https://via.placeholder.com/150',
    String rating = '4.5',
    String subtitle = 'Test Subtitle',
    List<String> sizes = const ['S', 'M', 'L'],
  }) {
    return ProductModel(
      id: id,
      title: title,
      price: price,
      description: description,
      imagePath: imagePath,
      rating: rating,
      subtitle: subtitle,
      sizes: sizes,
    );
  }

  static List<ProductModel> createTestProducts() {
    return [
      createTestProduct(id: 1, title: 'Product 1'),
      createTestProduct(id: 2, title: 'Product 2'),
      createTestProduct(id: 3, title: 'Product 3'),
    ];
  }

  static void mockSuccessfulGet(
    dynamic mockClient,
    String endpoint,
    String responseBody,
    {int statusCode = 200}
  ) {
    when(mockClient.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(responseBody, statusCode));
  }

  static void mockSuccessfulPost(
    dynamic mockClient,
    String endpoint,
    String responseBody,
    {int statusCode = 201}
  ) {
    when(mockClient.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(responseBody, statusCode));
  }

  static void mockSuccessfulPut(
    dynamic mockClient,
    String endpoint,
    String responseBody,
    {int statusCode = 200}
  ) {
    when(mockClient.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(responseBody, statusCode));
  }

  static void mockSuccessfulDelete(
    dynamic mockClient,
    String endpoint,
    {int statusCode = 200}
  ) {
    when(mockClient.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    )).thenAnswer((_) async => http.Response('', statusCode));
  }

  static void mockFailedRequest(
    dynamic mockClient,
    String endpoint,
    String method,
    {int statusCode = 500}
  ) {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    switch (method.toUpperCase()) {
      case 'GET':
        when(mockClient.get(uri, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Error', statusCode));
        break;
      case 'POST':
        when(mockClient.post(uri, headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) async => http.Response('Error', statusCode));
        break;
      case 'PUT':
        when(mockClient.put(uri, headers: headers, body: anyNamed('body')))
            .thenAnswer((_) async => http.Response('Error', statusCode));
        break;
      case 'DELETE':
        when(mockClient.delete(uri, headers: headers))
            .thenAnswer((_) async => http.Response('Error', statusCode));
        break;
    }
  }

  static void verifyGetCalled(dynamic mockClient, String endpoint, {int times = 1}) {
    verify(mockClient.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: anyNamed('headers'),
    )).called(times);
  }

  static void verifyPostCalled(dynamic mockClient, String endpoint, {int times = 1}) {
    verify(mockClient.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).called(times);
  }

  static void verifyPutCalled(dynamic mockClient, String endpoint, {int times = 1}) {
    verify(mockClient.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: anyNamed('body'),
    )).called(times);
  }

  static void verifyDeleteCalled(dynamic mockClient, String endpoint, {int times = 1}) {
    verify(mockClient.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    )).called(times);
  }
} 