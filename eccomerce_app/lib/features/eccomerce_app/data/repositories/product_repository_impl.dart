import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/platform/network_info.dart';
import '../../data/datasources/product_local_data_sources.dart';
import '../../data/datasources/product_remote_data_sources.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
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
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Try to get from remote source
        final remoteProducts = await remoteDataSource.getAllProducts();
        // Cache the products locally
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } else {
        // Get from local cache when offline
        final localProducts = await localDataSource.getAllProducts();
        return Right(localProducts);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(ServerFailure());
    } on ProductNotFoundException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Try to get from remote source
        final remoteProduct = await remoteDataSource.getProductById(id);
        // Cache the product locally
        await localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      } else {
        // Get from local cache when offline
        final localProduct = await localDataSource.getProductById(id);
        return Right(localProduct);
      }
    } on ServerException {
      return Left(ProductNotFoundFailure(id));
    } on CacheException {
      return Left(ProductNotFoundFailure(id));
    } on ProductNotFoundException {
      return Left(ProductNotFoundFailure(id));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Create in remote source
        await remoteDataSource.createProduct(product);
        // Cache locally
        await localDataSource.cacheProduct(product);
        return const Right(null);
      } else {
        // Cache locally when offline (will sync when online)
        await localDataSource.cacheProduct(product);
        return const Right(null);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(ServerFailure());
    } on ProductNotFoundException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Update in remote source
        await remoteDataSource.updateProduct(product);
        // Update local cache
        await localDataSource.updateProduct(product);
        return const Right(null);
      } else {
        // Update local cache when offline
        await localDataSource.updateProduct(product);
        return const Right(null);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(ServerFailure());
    } on ProductNotFoundException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Delete from remote source
        await remoteDataSource.deleteProduct(id);
        // Delete from local cache
        await localDataSource.deleteProduct(id);
        return const Right(null);
      } else {
        // Delete from local cache when offline
        await localDataSource.deleteProduct(id);
        return const Right(null);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(ServerFailure());
    } on ProductNotFoundException {
      return Left(ProductNotFoundFailure(id));
    }
  }
}
