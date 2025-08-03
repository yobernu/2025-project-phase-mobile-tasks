import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../domain/entities/product.dart';

abstract class ProductLocalDataSources {
  /// Get all products from local cache
  Future<List<Product>> getAllProducts();

  /// Get a specific product by ID from local cache
  Future<Product> getProductById(int id);

  /// Cache a list of products locally
  Future<void> cacheProducts(List<Product> products);

  /// Cache a single product locally
  Future<void> cacheProduct(Product product);

  /// Update a product in local cache
  Future<void> updateProduct(Product product);

  /// Delete a product from local cache
  Future<void> deleteProduct(int id);

  /// Clear all cached products
  Future<void> clearCache();
}

 // ignore: non_constant_identifier_names
final String CACHED_PRODUCTS = 'CACHED_PRODUCTS'; 

class ProductLocalDataSourcesImpl implements ProductLocalDataSources {
  final SharedPreferences sharedPreferences;
  ProductLocalDataSourcesImpl({required this.sharedPreferences});

  @override
  Future<List<Product>> getAllProducts() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final products = jsonList.map((json) => ProductModel.fromJson(json)).toList();
      return Future.value(products);
    } else {
      throw CacheException();
    }
  }
@override
Future<void> cacheProducts(List<Product> products) async {
  final jsonList = products.map((product) => product.toJson()).toList();
  final jsonString = json.encode(jsonList);
  await sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
}



  @override
  Future<void> cacheProduct(Product product) {
    // TODO: implement cacheProduct
    throw UnimplementedError();
  }

  

  @override
  Future<void> clearCache() {
    // TODO: implement clearCache
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(int id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
