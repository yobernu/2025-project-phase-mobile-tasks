import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/product_local_data_sources.dart';
import '../../data/datasources/product_remote_data_sources.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

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
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Try to get from remote source
        final remoteProductModels = await remoteDataSource.getAllProducts();
        // Convert ProductModel to Product for local caching
        final remoteProducts = remoteProductModels.map((model) => model as Product).toList();
        // Cache the products locally
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProductModels);
      } else {
        // Get from local cache when offline
        final localProducts = await localDataSource.getAllProducts();
        // Convert Product to ProductModel for return
        final localProductModels = localProducts.map((product) => ProductModel(
          id: product.id,
          price: product.price,
          description: product.description,
          title: product.title,
          imagePath: product.imagePath,
          rating: product.rating,
          sizes: product.sizes,
          subtitle: product.subtitle,
        )).toList();
        return Right(localProductModels);
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
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        // Try to get from remote source
        final remoteProductModel = await remoteDataSource.getProductById(id);
        // Convert ProductModel to Product for local caching
        final remoteProduct = remoteProductModel as Product;
        // Cache the product locally
        await localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProductModel);
      } else {
        // Get from local cache when offline
        final localProduct = await localDataSource.getProductById(id);
        // Convert Product to ProductModel for return
        final localProductModel = ProductModel(
          id: localProduct.id,
          price: localProduct.price,
          description: localProduct.description,
          title: localProduct.title,
          imagePath: localProduct.imagePath,
          rating: localProduct.rating,
          sizes: localProduct.sizes,
          subtitle: localProduct.subtitle,
        );
        return Right(localProductModel);
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
