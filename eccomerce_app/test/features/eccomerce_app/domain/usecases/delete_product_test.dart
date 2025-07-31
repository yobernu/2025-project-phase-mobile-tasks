import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';

// Simple mock implementation for testing
class MockProductRepository implements ProductRepository {
  bool _shouldSucceed = true;
  int? _lastDeletedId;

  void setShouldSucceed(bool shouldSucceed) {
    _shouldSucceed = shouldSucceed;
  }

  int? get lastDeletedId => _lastDeletedId;

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    return Left(ProductNotFoundFailure(id));
  }

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    _lastDeletedId = id;
    return _shouldSucceed 
        ? const Right(null)
        : Left(ServerFailure('Failed to delete product'));
  }
}

void main() {
  late DeleteProduct usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = DeleteProduct(mockProductRepository);
  });

  const testId = 1;

  test('should delete product successfully', () async {
    // arrange
    mockProductRepository.setShouldSucceed(true);

    // act
    final result = await usecase(DeleteProductParams(testId));

    // assert
    expect(result, const Right(null));
    expect(mockProductRepository.lastDeletedId, testId);
  });

  test('should return failure when product deletion fails', () async {
    // arrange
    mockProductRepository.setShouldSucceed(false);

    // act
    final result = await usecase(DeleteProductParams(testId));

    // assert
    expect(result, Left(ServerFailure('Failed to delete product')));
    expect(mockProductRepository.lastDeletedId, testId);
  });
} 