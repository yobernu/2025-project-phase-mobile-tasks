import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';

// Simple mock implementation for testing
class MockProductRepository implements ProductRepository {
  bool _shouldSucceed = true;
  Product? _lastInsertedProduct;

  void setShouldSucceed(bool shouldSucceed) {
    _shouldSucceed = shouldSucceed;
  }

  Product? get lastInsertedProduct => _lastInsertedProduct;

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
    _lastInsertedProduct = product;
    return _shouldSucceed 
        ? const Right(null)
        : Left(ServerFailure('Failed to create product'));
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    return const Right(null);
  }
}

void main() {
  late InsertProduct usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = InsertProduct(mockProductRepository);
  });

  const testProduct = Product(
    id: 1,
    imagePath: 'test_image.jpg',
    title: 'Test Product',
    subtitle: 'Test Subtitle',
    price: '99.99',
    rating: '4.5',
    sizes: ['S', 'M', 'L'],
    description: 'Test description',
  );

  test('should insert product successfully', () async {
    // arrange
    mockProductRepository.setShouldSucceed(true);

    // act
    final result = await usecase(InsertProductParams(testProduct));

    // assert
    expect(result, const Right(null));
    expect(mockProductRepository.lastInsertedProduct, testProduct);
  });

  test('should return failure when product insertion fails', () async {
    // arrange
    mockProductRepository.setShouldSucceed(false);

    // act
    final result = await usecase(InsertProductParams(testProduct));

    // assert
    expect(result, Left(ServerFailure('Failed to create product')));
    expect(mockProductRepository.lastInsertedProduct, testProduct);
  });
} 