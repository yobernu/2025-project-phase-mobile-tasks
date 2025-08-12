import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:async';
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSources {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(Product product);
  Future<ProductModel> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourcesImpl implements ProductRemoteDataSources {
  final http.Client client;
  final AuthService authService;
  static const String _tag = 'ProductRemoteDS';

  ProductRemoteDataSourcesImpl({
    required this.client,
    required this.authService,
  });

  Map<String, String> _buildHeaders() {
    final token = authService.getToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
      );
      dev.log('Requesting products from: $uri', name: _tag);

      final response = await client
          .get(uri, headers: _buildHeaders())
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
      throw NetworkException('No internet connection');
    } on TimeoutException {
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
          .get(uri, headers: _buildHeaders())
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

      dev.log('Creating product at: $uri', name: _tag);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add headers including auth token
      final headers = _buildHeaders();
      headers.remove(HttpHeaders.contentTypeHeader); // Remove JSON content-type
      request.headers.addAll(headers);

      // Add text fields
      request.fields['name'] = product.name;
      request.fields['description'] = product.description;
      request.fields['price'] = product.price;
      if (product.subtitle != null) {
        request.fields['subtitle'] = product.subtitle!;
      }
      if (product.rating != null) request.fields['rating'] = product.rating!;
      if (product.sizes != null && product.sizes!.isNotEmpty) {
        request.fields['sizes'] = product.sizes!.join(',');
      }

      // Add image file
      final imageFile = File(product.imageUrl);
      if (await imageFile.exists()) {
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: product.imageUrl.split('/').last,
          contentType: MediaType('image', '*'),
        );
        request.files.add(multipartFile);
      } else {
        throw ServerException('Image file not found');
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
          .put(uri, headers: _buildHeaders(), body: body)
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
  Future<void> deleteProduct(String id) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id',
      );
      dev.log('Deleting product #$id at: $uri', name: _tag);

      final response = await client
          .delete(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 15));

      _logResponse(response);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw _handleStatusCode(response.statusCode, response.body);
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    } catch (e) {
      dev.log('Error deleting product #$id: $e', name: _tag, error: e);
      rethrow;
    }
  }

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
