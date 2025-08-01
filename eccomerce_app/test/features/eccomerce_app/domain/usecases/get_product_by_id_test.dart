import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';

// Simple mock implementation for testing
class MockProductRepository implements ProductRepository {
  Either<Failure, Product>? _productToReturn;
  int? _lastRequestedId;

  void setProductToReturn(Either<Failure, Product>? product) {
    _productToReturn = product;
  }

  int? get lastRequestedId => _lastRequestedId;

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    return _productToReturn != null && _productToReturn!.isRight() 
        ? Right([_productToReturn!.getOrElse(() => throw Exception())])
        : Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    _lastRequestedId = id;
    return _productToReturn ?? Left(ProductNotFoundFailure(id));
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
    imagePath: 'test_image.jpg',
    title: 'Test Product',
    subtitle: 'Test Subtitle',
    price: '99.99',
    rating: '4.5',
    sizes: ['S', 'M', 'L'],
    description: 'Test description',
  );

  test('should get product from repository', () async {
    // arrange
    mockProductRepository.setProductToReturn(Right(testProduct));

    // act
    final result = await usecase(GetProductByIdParams(testId));

    // assert
    expect(result, Right(testProduct));
    expect(mockProductRepository.lastRequestedId, testId);
  });

  test('should return failure when product not found', () async {
    // arrange
    mockProductRepository.setProductToReturn(Left(ProductNotFoundFailure(testId)));

    // act
    final result = await usecase(GetProductByIdParams(testId));

    // assert
    expect(result, Left(ProductNotFoundFailure(testId)));
    expect(mockProductRepository.lastRequestedId, testId);
  });
}