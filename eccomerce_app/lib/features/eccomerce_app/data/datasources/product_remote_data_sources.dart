import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSources {
  /// Get all products from remote source
  Future<List<Product>> getAllProducts();
  
  /// Get a specific product by ID from remote source
  Future<Product> getProductById(int id);
  
  /// Create a new product in remote source
  Future<void> createProduct(Product product);
  
  /// Update an existing product in remote source
  Future<void> updateProduct(Product product);
  
  /// Delete a product by ID from remote source
  Future<void> deleteProduct(int id);
}