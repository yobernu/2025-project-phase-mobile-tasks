import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
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