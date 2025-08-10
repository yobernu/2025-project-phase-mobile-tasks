import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSources {
  /// Get all products from remote source
  Future<List<ProductModel>> getAllProducts();

  /// Get a specific product by ID from remote source
  Future<ProductModel> getProductById(String id);

  /// Create a new product in remote source
  Future<ProductModel> createProduct(Product product);

  /// Update an existing product in remote source
  Future<ProductModel> updateProduct(Product product);

  /// Delete a product by ID from remote source
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourcesImpl implements ProductRemoteDataSources {
  final http.Client client;
  static const String _tag = 'ProductRemoteDS';

  ProductRemoteDataSourcesImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
      );
      dev.log('Requesting products from: $uri', name: _tag);

      final response = await client
          .get(uri, headers: ApiConstants.headers)
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> productsJson = decoded['data'] ?? [];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw _handleStatusCode(response.statusCode, response.body);
      }
    } on SocketException {
      dev.log('No internet connection', name: _tag);
      throw NetworkException('No internet connection');
    } on TimeoutException {
      dev.log('Request timeout', name: _tag);
      throw NetworkException('Request timeout');
    } catch (e) {
      dev.log('Unexpected error: $e', name: _tag, error: e);
      throw ServerException('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id',
      );
      dev.log('Requesting product #$id from: $uri', name: _tag);

      final response = await client
          .get(uri, headers: ApiConstants.headers)
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw _handleStatusCode(response.statusCode, response.body);
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    } catch (e) {
      dev.log('Error getting product #$id: $e', name: _tag, error: e);
      throw ServerException('Failed to load product');
    }
  }

  @override
  Future<ProductModel> createProduct(Product product) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
      );
      final body = json.encode(product.toJson());

      dev.log('Creating product at: $uri', name: _tag);
      dev.log('Request body: $body', name: _tag);

      final response = await client
          .post(uri, headers: ApiConstants.headers, body: body)
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode == 201) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw _handleStatusCode(response.statusCode, response.body);
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    } catch (e) {
      dev.log('Error creating product: $e', name: _tag, error: e);
      throw ServerException('Failed to create product');
    }
  }

  @override
  Future<ProductModel> updateProduct(Product product) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/${product.id}',
      );
      final body = json.encode(product.toJson());

      dev.log('Updating product at: $uri', name: _tag);
      dev.log('Request body: $body', name: _tag);

      final response = await client
          .put(uri, headers: ApiConstants.headers, body: body)
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw _handleStatusCode(response.statusCode, response.body);
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    } catch (e) {
      dev.log('Error updating product: $e', name: _tag, error: e);
      throw ServerException('Failed to update product');
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id',
      );
      dev.log('Deleting product #$id at: $uri', name: _tag);

      final response = await client
          .delete(uri, headers: ApiConstants.headers)
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      } else {
        return Left(
          ServerFailure('Failed to delete product (${response.statusCode})'),
        );
      }
    } on SocketException {
      return Left(NetworkFailure('No internet connection'));
    } on TimeoutException {
      return Left(NetworkFailure('Request timeout'));
    } catch (e) {
      dev.log('Error deleting product #$id: $e', name: _tag, error: e);
      return Left(ServerFailure('Failed to delete product'));
    }
  }

  // Helper methods
  void _logResponse(http.Response response) {
    dev.log('Response status: ${response.statusCode}', name: _tag);
    dev.log('Response body: ${response.body}', name: _tag);
  }

  Exception _handleStatusCode(int statusCode, String body) {
    dev.log('Error status: $statusCode, body: $body', name: _tag);

    switch (statusCode) {
      case 400:
        return BadRequestException(body.isNotEmpty ? body : 'Invalid request');
      case 401:
        return UnauthorizedException();
      case 403:
        return ForbiddenException();
      case 404:
        return NotFoundException('Product not found: $body');
      case 500:
        return ServerException('Internal server error: $body');
      default:
        return ServerException('HTTP $statusCode: $body');
    }
  }
}
