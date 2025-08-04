import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';

// Simple mock implementation for testing
class MockProductRepository implements ProductRepository {
  bool _shouldSucceed = true;
  int? _lastRequestedId;

  void setShouldSucceed(bool shouldSucceed) {
    _shouldSucceed = shouldSucceed;
  }

  int? get lastRequestedId => _lastRequestedId;

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    _lastRequestedId = id;
    if (_shouldSucceed) {
      return Right(ProductModel(
        id: id,
        price: '100',
        description: 'Test Description',
        title: 'Test Product',
        imagePath: 'https://test.com/image.jpg',
        rating: '4.5',
        sizes: ['S', 'M', 'L'],
        subtitle: 'Test Subtitle',
      ));
    } else {
      return Left(ProductNotFoundFailure(id));
    }
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
    return const Right(null);
  }
}

void main() {
  late GetProductById usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetProductById(mockProductRepository);
  });

  const testId = 1;
  const testProduct = Product(
    id: testId,
    imagePath: 'https://test.com/image.jpg',
    title: 'Test Product',
    subtitle: 'Test Subtitle',
    price: '100',
    rating: '4.5',
    sizes: ['S', 'M', 'L'],
    description: 'Test Description',
  );

  test('should get product from repository', () async {
    // arrange
    mockProductRepository.setShouldSucceed(true);

    // act
    final result = await usecase(GetProductByIdParams(testId));

    // assert
    expect(result.isRight(), true);
    final product = (result as Right).value;
    expect(product.id, equals(testId));
    expect(product.title, equals('Test Product'));
    expect(product.price, equals('100'));
    expect(mockProductRepository.lastRequestedId, testId);
  });

  test('should return failure when product not found', () async {
    // arrange
    mockProductRepository.setShouldSucceed(false);

    // act
    final result = await usecase(GetProductByIdParams(testId));

    // assert
    expect(result, Left(ProductNotFoundFailure(testId)));
    expect(mockProductRepository.lastRequestedId, testId);
  });
}