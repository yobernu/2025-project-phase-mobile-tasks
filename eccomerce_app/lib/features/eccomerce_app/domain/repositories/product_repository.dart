import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  // Get all products
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  
  // Get a specific product by ID
  Future<Either<Failure, ProductModel>> getProductById(int id);
  
  // Create a new product
  Future<Either<Failure, void>> createProduct(Product product);
  
  // Update an existing product
  Future<Either<Failure, void>> updateProduct(Product product);
  
  // Delete a product by ID
  Future<Either<Failure, void>> deleteProduct(int id);
} 