import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourcesImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourcesImpl(client: mockHttpClient);
  });

  final urlid = Uri.parse('https://fakestoreapi.com/products/1');
  final headers = {'Content-Type': 'application/json'};

  group('getAllProducts', () {
    test('should return all products when the response is successful', () async {
      // Arrange
      final productsJson = fixtures('products.json');
      final productsList = json.decode(productsJson) as List<dynamic>;
      final expectedProducts = productsList.map((json) => ProductModel.fromJson(json)).toList();
      
      when(mockHttpClient.get(Uri.parse('https://fakestoreapi.com/products'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(productsJson, 200));

      // Act
      final result = await dataSource.getAllProducts();

      // Assert
      verify(mockHttpClient.get(Uri.parse('https://fakestoreapi.com/products'), headers: anyNamed('headers'))).called(1);
      expect(result, equals(expectedProducts));
    });

    test('should throw ServerException when the response is not successful', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse('https://fakestoreapi.com/products'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      // Act & Assert
      expect(() => dataSource.getAllProducts(), throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(Uri.parse('https://fakestoreapi.com/products'), headers: anyNamed('headers'))).called(1);
    });
  });

  group('getProductById', () {
    test('should return a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      when(mockHttpClient.get(urlid, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(productJson, 200));
      
      // Act
      final result = await dataSource.getProductById(1);

      // Assert
      verify(mockHttpClient.get(urlid, headers: anyNamed('headers'))).called(1);
      expect(result, equals(expectedProduct));
    });

    test('should throw ServerException when the response is not successful', () async {
      // Arrange
      when(mockHttpClient.get(urlid, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));
      
      // Act & Assert
      expect(() => dataSource.getProductById(1), throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(urlid, headers: anyNamed('headers'))).called(1);
    });
  });

  group('createProduct', () {
    final product = ProductModel(
      id: 1,
      title: 'Test Product',
      price: '100',
      description: 'Test Description',
      imagePath: 'https://via.placeholder.com/150',
      rating: '4.5',
      subtitle: 'Test Subtitle',
      sizes: ['S', 'M', 'L'],
    );

    test('should create a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      when(mockHttpClient.post(
        Uri.parse('https://fakestoreapi.com/products'), 
        headers: anyNamed('headers'), 
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response(productJson, 201));
      
      // Act
      final result = await dataSource.createProduct(product);

      // Assert
      verify(mockHttpClient.post(
        Uri.parse('https://fakestoreapi.com/products'), 
        headers: anyNamed('headers'), 
        body: anyNamed('body')
      )).called(1);
      expect(result, equals(expectedProduct));
    });

    test('should throw a ServerException when the response is not successful', () async {
      // Arrange
      when(mockHttpClient.post(
        Uri.parse('https://fakestoreapi.com/products'), 
        headers: anyNamed('headers'), 
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response('Error', 500));
      
      // Act & Assert
      expect(() => dataSource.createProduct(product), throwsA(isA<ServerException>()));
      verify(mockHttpClient.post(
        Uri.parse('https://fakestoreapi.com/products'), 
        headers: anyNamed('headers'), 
        body: anyNamed('body')
      )).called(1);
    });
  });

  group('deleteProduct', () {
    test('should delete a product when the response is successful', () async {
      // Arrange
      when(mockHttpClient.delete(urlid, headers: headers))
          .thenAnswer((_) async => http.Response('', 200));
      
      // Act
      await dataSource.deleteProduct(1);

      // Assert
      verify(mockHttpClient.delete(urlid, headers: headers)).called(1);
    });

    test('should throw a ServerException when the response is not successful', () async {
      // Arrange
      when(mockHttpClient.delete(urlid, headers: headers))
          .thenAnswer((_) async => http.Response('Error', 500));
      
      // Act & Assert
      expect(() => dataSource.deleteProduct(1), throwsA(isA<ServerException>()));
      verify(mockHttpClient.delete(urlid, headers: headers)).called(1);
    });
  });

  group('updateProduct', () {
    final product = ProductModel(
      id: 1,
      title: 'Test Product',
      price: '100',
      description: 'Test Description',
      imagePath: 'https://via.placeholder.com/150',
      rating: '4.5',
      subtitle: 'Test Subtitle',
      sizes: ['S', 'M', 'L'],
    );

    test('should update a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      when(mockHttpClient.put(urlid, headers: headers, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(productJson, 200));
      
      // Act
      final result = await dataSource.updateProduct(product);

      // Assert
      verify(mockHttpClient.put(urlid, headers: headers, body: anyNamed('body'))).called(1);
      expect(result, equals(expectedProduct));
    });

    test('should throw a ServerException when the response is not successful', () async {
      // Arrange
      when(mockHttpClient.put(urlid, headers: headers, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));
      
      // Act & Assert
      expect(() => dataSource.updateProduct(product), throwsA(isA<ServerException>()));
      verify(mockHttpClient.put(urlid, headers: headers, body: anyNamed('body'))).called(1);
    });
  });
}