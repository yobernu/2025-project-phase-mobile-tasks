import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import '../../domain/entities/product.dart';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSources {
  /// Get all products from remote source
  Future<List<ProductModel>> getAllProducts();

  /// Get a specific product by ID from remote source
  Future<ProductModel> getProductById(int id);

  /// Create a new product in remote source
  Future<ProductModel> createProduct(Product product);

  /// Update an existing product in remote source
  Future<ProductModel> updateProduct(Product product);

  /// Delete a product by ID from remote source
  Future<void> deleteProduct(int id);
}

class ProductRemoteDataSourcesImpl implements ProductRemoteDataSources {
  final http.Client client;
  ProductRemoteDataSourcesImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ProductModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct(Product product) async {
    final response = await client.post(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return ProductModel.fromJson(responseData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(Product product) async {
    final response = await client.put(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${product.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
