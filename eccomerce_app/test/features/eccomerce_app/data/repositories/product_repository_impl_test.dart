import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_local_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';

import 'product_repository_impl_test.mocks.dart';

// Generate mocks for testing
@GenerateMocks([ProductRemoteDataSources, ProductLocalDataSources, NetworkInfo])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSources mockRemoteDataSource;
  late MockProductLocalDataSources mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final tProduct = Product(
    id: 1,
    price: '100',
    description: 'Test Description',
    title: 'Test Product',
    imagePath: 'https://test.com/image.jpg',
    rating: '4.5',
    sizes: ['S', 'M', 'L'],
    subtitle: 'Test Subtitle',
  );

  final tProducts = [tProduct];

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSources();
    mockLocalDataSource = MockProductLocalDataSources();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });




// getallproducts
  group('getAllProducts - Online/Offline Scenarios', () {
    test('should fetch from remote and cache when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);
      when(
        mockLocalDataSource.cacheProducts(tProducts),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getAllProducts());
      verify(mockLocalDataSource.cacheProducts(tProducts));
      expect(result, Right(tProducts));
    });

    test('should fetch from local when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        mockLocalDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAllProducts());
      verifyNever(mockRemoteDataSource.getAllProducts());
      expect(result, Right(tProducts));
    });

    test('should return ServerFailure when remote fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts()).thenThrow(ServerException());

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result.isLeft(), true);
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
    });

    test('should return ServerFailure when local fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProducts()).thenThrow(CacheException());

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result.isLeft(), true);
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
    });

    test('should return ServerFailure when remote throws ProductNotFoundException', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts()).thenThrow(ProductNotFoundException());

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result.isLeft(), true);
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
    });

    test('should return ServerFailure when local throws ProductNotFoundException', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProducts()).thenThrow(ProductNotFoundException());

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result.isLeft(), true);
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
    });
  });







// getproductbyid
  group('getProductById - Online/Offline Scenarios', () {
    test(
      'should fetch product by id from remote and cache when online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getProductById(tProduct.id),
        ).thenAnswer((_) async => tProduct);
        when(
          mockLocalDataSource.cacheProduct(tProduct),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getProductById(tProduct.id);

        // Assert
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.getProductById(tProduct.id));
        verify(mockLocalDataSource.cacheProduct(tProduct));
        expect(result, Right(tProduct));
      },
    );

    test('should fetch from local when offline - for getProductById', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        mockLocalDataSource.getProductById(tProduct.id),
      ).thenAnswer((_) async => tProduct);

      // Act
      final result = await repository.getProductById(tProduct.id);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getProductById(tProduct.id));
      verifyNever(mockRemoteDataSource.getProductById(tProduct.id));
      expect(result, Right(tProduct));
    });

    test(
      'should return ProductNotFoundFailure when remote fails - for getProductById',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getProductById(tProduct.id),
        ).thenThrow(ServerException());

        // Act
        final result = await repository.getProductById(tProduct.id);

        // Assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ProductNotFoundFailure>());
        expect(
          (failure as ProductNotFoundFailure).productId,
          equals(tProduct.id),
        );
      },
    );

    test(
      'should return ProductNotFoundFailure when local fails - for getProductById',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.getProductById(tProduct.id),
        ).thenThrow(CacheException());

        // Act
        final result = await repository.getProductById(tProduct.id);

        // Assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ProductNotFoundFailure>());
        expect(
          (failure as ProductNotFoundFailure).productId,
          equals(tProduct.id),
        );
      },
    );

    test(
      'should return ProductNotFoundFailure when remote throws ProductNotFoundException - for getProductById',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getProductById(tProduct.id),
        ).thenThrow(ProductNotFoundException());

        // Act
        final result = await repository.getProductById(tProduct.id);

        // Assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ProductNotFoundFailure>());
        expect(
          (failure as ProductNotFoundFailure).productId,
          equals(tProduct.id),
        );
      },
    );

    test(
      'should return ProductNotFoundFailure when local throws ProductNotFoundException - for getProductById',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.getProductById(tProduct.id),
        ).thenThrow(ProductNotFoundException());

        // Act
        final result = await repository.getProductById(tProduct.id);

        // Assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ProductNotFoundFailure>());
        expect(
          (failure as ProductNotFoundFailure).productId,
          equals(tProduct.id),
        );
      },
    );
  });





// createproduct

  group('createProduct - Online/Offline Scenarios', () {
    test('should create product in remote and cache when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.createProduct(tProduct),
      ).thenAnswer((_) async => tProduct);
      when(mockLocalDataSource.cacheProduct(tProduct)).thenAnswer((_) async {});
      // act
      final result = await repository.createProduct(tProduct);

      // assert

      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.createProduct(tProduct));
      verify(mockLocalDataSource.cacheProduct(tProduct));
      expect(result, const Right(null));
    });

    test(
      'should create product in local when offline - for createProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.cacheProduct(tProduct),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.createProduct(tProduct);
        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockLocalDataSource.cacheProduct(tProduct));
        verifyNever(mockRemoteDataSource.createProduct(tProduct));
        expect(result, const Right(null));
      },
    );

    test(
      'should return ServerFailure when remote fails - for createProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.createProduct(tProduct),
        ).thenThrow(ServerException());
        // act
        final result = await repository.createProduct(tProduct);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      'should return ServerFailure when local fails - for createProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.cacheProduct(tProduct),
        ).thenThrow(CacheException());
        // act
        final result = await repository.createProduct(tProduct);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );
  });










// updateproduct
  group('updateProduct - Online/Offline Scenarios', () {
    test('should update product in remote and cache when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.updateProduct(tProduct),
      ).thenAnswer((_) async {});
      when(mockLocalDataSource.updateProduct(tProduct)).thenAnswer((_) async {});
      // act
      final result = await repository.updateProduct(tProduct);

      // assert

      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.updateProduct(tProduct));
      verify(mockLocalDataSource.updateProduct(tProduct));
      expect(result, const Right(null));
    });

    test(
      'should update product in local when offline - for updateProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.updateProduct(tProduct),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.updateProduct(tProduct);
        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockLocalDataSource.updateProduct(tProduct));
        verifyNever(mockRemoteDataSource.updateProduct(tProduct));
        expect(result, const Right(null));
      },
    );

    test(
      'should return ServerFailure when remote fails - for updateProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.updateProduct(tProduct),
        ).thenThrow(ServerException());
        // act
        final result = await repository.updateProduct(tProduct);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      'should return ServerFailure when local fails - for updateProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.updateProduct(tProduct),
        ).thenThrow(CacheException());
        // act
        final result = await repository.updateProduct(tProduct);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );
  });






  // deleteproduct
  group('deleteProduct - Online/Offline Scenarios', () {
    test('should delete product in remote and cache when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.deleteProduct(tProduct.id),
      ).thenAnswer((_) async {});
      when(mockLocalDataSource.deleteProduct(tProduct.id)).thenAnswer((_) async {});
      // act
      final result = await repository.deleteProduct(tProduct.id);

      // assert

      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.deleteProduct(tProduct.id));
      verify(mockLocalDataSource.deleteProduct(tProduct.id));
      expect(result, const Right(null));
    });

    test(
      'should delete product in local when offline - for deleteProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.deleteProduct(tProduct.id),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.deleteProduct(tProduct.id);
        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockLocalDataSource.deleteProduct(tProduct.id));
        verifyNever(mockRemoteDataSource.deleteProduct(tProduct.id));
        expect(result, const Right(null));
      },
    );

    test(
      'should return ServerFailure when remote fails - for deleteProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.deleteProduct(tProduct.id),
        ).thenThrow(ServerException());
        // act
        final result = await repository.deleteProduct(tProduct.id);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      'should return ProductNotFoundFailure when remote throws ProductNotFoundException - for deleteProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.deleteProduct(tProduct.id),
        ).thenThrow(ProductNotFoundException());
        // act
        final result = await repository.deleteProduct(tProduct.id);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ProductNotFoundFailure>());
        expect((failure as ProductNotFoundFailure).productId, equals(tProduct.id));
      },
    );

    test(
      'should return ServerFailure when local fails - for deleteProduct',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.deleteProduct(tProduct.id),
        ).thenThrow(CacheException());
        // act
        final result = await repository.deleteProduct(tProduct.id);
        // assert
        expect(result.isLeft(), true);
        final failure = (result as Left).value;
        expect(failure, isA<ServerFailure>());
      },
    );

    test('should return ProductNotFoundFailure when local throws ProductNotFoundException - for deleteProduct', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.deleteProduct(tProduct.id))
          .thenThrow(ProductNotFoundException());
      // act
      final result = await repository.deleteProduct(tProduct.id);
      // assert
      expect(result.isLeft(), true);
      final failure = (result as Left).value;
      expect(failure, isA<ProductNotFoundFailure>());
      expect((failure as ProductNotFoundFailure).productId, equals(tProduct.id));
    });
  });






}




// getallproducts
// getproductbyid
// createproduct
// updateproduct
// deleteproduct






