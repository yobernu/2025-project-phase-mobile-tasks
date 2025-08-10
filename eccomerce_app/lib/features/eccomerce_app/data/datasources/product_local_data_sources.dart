import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../domain/entities/product.dart';

abstract class ProductLocalDataSources {
  /// Get all products from local cache
  Future<List<Product>> getAllProducts();

  /// Get a specific product by ID from local cache
  Future<Product> getProductById(String id);

  /// Cache a list of products locally
  Future<void> cacheProducts(List<Product> products);

  /// Cache a single product locally
  Future<void> cacheProduct(Product product);

  /// Update a product in local cache
  Future<void> updateProduct(Product product);

  /// Delete a product from local cache
  Future<void> deleteProduct(String id);

  /// Clear all cached products
  Future<void> clearCache();
}

 // ignore: non_constant_identifier_names
final String CACHED_PRODUCTS = 'CACHED_PRODUCTS'; 
// ignore: non_constant_identifier_names
final String CACHED_PRODUCT = 'CACHED_PRODUCT';

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
  Future<void> cacheProduct(Product product) async {
    final jsonString = json.encode(product.toJson());
    await sharedPreferences.setString(CACHED_PRODUCT, jsonString);
  }

  

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(CACHED_PRODUCTS);
    await sharedPreferences.remove(CACHED_PRODUCT);
  }

  @override
  Future<void> deleteProduct(String id) async{
    await sharedPreferences.remove('CACHED_PRODUCT_$id');
    }


  @override
  Future<Product> getProductById(String id) {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_$id');
    if (jsonString != null) {
      final product = ProductModel.fromJson(json.decode(jsonString));
      return Future.value(product);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final jsonString = json.encode(product.toJson());
    await sharedPreferences.setString('CACHED_PRODUCT_${product.id}', jsonString);
  }
}
