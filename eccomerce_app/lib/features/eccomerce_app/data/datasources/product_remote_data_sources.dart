import 'dart:convert';
import 'dart:developer' as dev;
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import '../../domain/entities/product.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';


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
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}'), 
        headers: ApiConstants.headers,
      );
      
      dev.log('API Response Status: ${response.statusCode}');
      dev.log('API Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        dev.log('Server error: ${response.statusCode} - ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      dev.log('Exception in getAllProducts: $e');
      throw ServerException();
    }
  }

    @override
  Future<ProductModel> getProductById(int id) async{
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id'), 
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ProductModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct(Product product) async{
     final response = await client.post(
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}'),
    headers: ApiConstants.headers,
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
  Future<void> deleteProduct(int id) async{
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id'), 
      headers: ApiConstants.headers,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  
  }

  @override
  Future<ProductModel> updateProduct(Product product) async{
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/${product.id}'),
      headers: ApiConstants.headers,
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}