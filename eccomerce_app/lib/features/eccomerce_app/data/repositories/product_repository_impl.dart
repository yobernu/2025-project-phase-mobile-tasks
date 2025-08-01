import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../data/datasources/product_local_data_sources.dart';
import '../../data/datasources/product_remote_data_sources.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {

  final List<Product> _products = [];
  final ProductRemoteDataSources remoteDataSource;
  final ProductLocalDataSources localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });




  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      return Right(_products);
    } catch (e) {
      return Left(ServerFailure('Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final product = _products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      return Right(product);
    } catch (e) {
      return Left(ProductNotFoundFailure(id));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    try {
      // Check if product with same ID already exists
      if (_products.any((p) => p.id == product.id)) {
        return Left(ServerFailure('Product with ID ${product.id} already exists'));
      }
      
      _products.add(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to create product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        return Left(ProductNotFoundFailure(product.id));
      }
      
      _products[index] = product;
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      final index = _products.indexWhere((p) => p.id == id);
      if (index == -1) {
        return Left(ProductNotFoundFailure(id));
      }
      
      _products.removeAt(index);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete product: $e'));
    }
  }
} 