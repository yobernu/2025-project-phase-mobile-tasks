import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
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
      if (await networkInfo.isConnected) {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } else {
        final localProducts = await localDataSource.getAllProducts();
        if (localProducts.isEmpty) {
          return Left(CacheFailure('No products found in cache'));
        }
        return Right(localProducts);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProduct = await remoteDataSource.getProductById(id);
        await localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      } else {
        final localProduct = await localDataSource.getProductById(id);
        return Right(localProduct);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ProductNotFoundException {
      return Left(ProductNotFoundFailure(id));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load product'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      if (await networkInfo.isConnected) {
        final createdProduct = await remoteDataSource.createProduct(product);
        await localDataSource.cacheProduct(createdProduct);
        return Right(createdProduct);
      } else {
        await localDataSource.cacheProduct(product);
        return Right(product);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create product'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      if (await networkInfo.isConnected) {
        final updatedProduct = await remoteDataSource.updateProduct(product);
        await localDataSource.cacheProduct(updatedProduct);
        return Right(updatedProduct);
      } else {
        await localDataSource.cacheProduct(product);
        return Right(product);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ProductNotFoundException {
      return Left(ProductNotFoundFailure(product.id));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update product'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteProduct(id);
      }
      await localDataSource.deleteProduct(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ProductNotFoundException {
      return Left(ProductNotFoundFailure(id));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete product'));
    }
  }
}
