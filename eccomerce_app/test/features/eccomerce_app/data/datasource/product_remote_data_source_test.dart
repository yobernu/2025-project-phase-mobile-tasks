import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';
import '../../../../core/test_helpers.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourcesImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourcesImpl(client: mockHttpClient);
  });

  group('getAllProducts', () {
    test(
      'should return all products when the response is successful',
      () async {
        // Arrange
        final productsJson = fixtures('products.json');
        final productsList = json.decode(productsJson) as List<dynamic>;
        final expectedProducts = productsList
            .map((json) => ProductModel.fromJson(json))
            .toList();

        TestHelpers.mockSuccessfulGet(
          mockHttpClient,
          '/products',
          productsJson,
        );

        // Act
        final result = await dataSource.getAllProducts();

        // Assert
        TestHelpers.verifyGetCalled(mockHttpClient, '/products');
        expect(result, equals(expectedProducts));
      },
    );

    test(
      'should throw ServerException when the response is not successful',
      () async {
        // Arrange
        TestHelpers.mockFailedRequest(mockHttpClient, '/products', 'GET');

        // Act & Assert
        expect(
          () => dataSource.getAllProducts(),
          throwsA(isA<ServerException>()),
        );
        TestHelpers.verifyGetCalled(mockHttpClient, '/products');
      },
    );
  });

  group('getProductById', () {
    test('should return a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      TestHelpers.mockSuccessfulGet(mockHttpClient, '/products/1', productJson);

      // Act
      final result = await dataSource.getProductById(1);

      // Assert
      TestHelpers.verifyGetCalled(mockHttpClient, '/products/1');
      expect(result, equals(expectedProduct));
    });

    test(
      'should throw ServerException when the response is not successful',
      () async {
        // Arrange
        TestHelpers.mockFailedRequest(mockHttpClient, '/products/1', 'GET');

        // Act & Assert
        expect(
          () => dataSource.getProductById(1),
          throwsA(isA<ServerException>()),
        );
        TestHelpers.verifyGetCalled(mockHttpClient, '/products/1');
      },
    );
  });

  group('createProduct', () {
    final product = TestHelpers.createTestProduct();

    test('should create a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      TestHelpers.mockSuccessfulPost(mockHttpClient, '/products', productJson);

      // Act
      final result = await dataSource.createProduct(product);

      // Assert
      TestHelpers.verifyPostCalled(mockHttpClient, '/products');
      expect(result, equals(expectedProduct));
    });

    test(
      'should throw a ServerException when the response is not successful',
      () async {
        // Arrange
        TestHelpers.mockFailedRequest(mockHttpClient, '/products', 'POST');

        // Act & Assert
        expect(
          () => dataSource.createProduct(product),
          throwsA(isA<ServerException>()),
        );
        TestHelpers.verifyPostCalled(mockHttpClient, '/products');
      },
    );
  });

  group('deleteProduct', () {
    test('should delete a product when the response is successful', () async {
      // Arrange
      TestHelpers.mockSuccessfulDelete(mockHttpClient, '/products/1');

      // Act
      await dataSource.deleteProduct(1);

      // Assert
      TestHelpers.verifyDeleteCalled(mockHttpClient, '/products/1');
    });

    test(
      'should throw a ServerException when the response is not successful',
      () async {
        // Arrange
        TestHelpers.mockFailedRequest(mockHttpClient, '/products/1', 'DELETE');

        // Act & Assert
        expect(
          () => dataSource.deleteProduct(1),
          throwsA(isA<ServerException>()),
        );
        TestHelpers.verifyDeleteCalled(mockHttpClient, '/products/1');
      },
    );
  });

  group('updateProduct', () {
    final product = TestHelpers.createTestProduct();

    test('should update a product when the response is successful', () async {
      // Arrange
      final productJson = fixtures('product.json');
      final expectedProduct = ProductModel.fromJson(json.decode(productJson));
      TestHelpers.mockSuccessfulPut(mockHttpClient, '/products/1', productJson);

      // Act
      final result = await dataSource.updateProduct(product);

      // Assert
      TestHelpers.verifyPutCalled(mockHttpClient, '/products/1');
      expect(result, equals(expectedProduct));
    });

    test(
      'should throw a ServerException when the response is not successful',
      () async {
        // Arrange
        TestHelpers.mockFailedRequest(mockHttpClient, '/products/1', 'PUT');

        // Act & Assert
        expect(
          () => dataSource.updateProduct(product),
          throwsA(isA<ServerException>()),
        );
        TestHelpers.verifyPutCalled(mockHttpClient, '/products/1');
      },
    );
  });
}
