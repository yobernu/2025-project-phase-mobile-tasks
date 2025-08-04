import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';

// Simple mock implementation for testing
class MockProductRepository implements ProductRepository {
  bool _shouldSucceed = true;
  Product? _lastUpdatedProduct;

  void setShouldSucceed(bool shouldSucceed) {
    _shouldSucceed = shouldSucceed;
  }

  Product? get lastUpdatedProduct => _lastUpdatedProduct;

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    return Left(ProductNotFoundFailure(id));
  }

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    _lastUpdatedProduct = product;
    return _shouldSucceed 
        ? const Right(null)
        : Left(ServerFailure('Failed to update product'));
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    return const Right(null);
  }
}

void main() {
  late UpdateProduct usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = UpdateProduct(mockProductRepository);
  });

  const testProduct = Product(
    id: 1,
    imagePath: 'test_image.jpg',
    title: 'Updated Product',
    subtitle: 'Updated Subtitle',
    price: '149.99',
    rating: '4.8',
    sizes: ['S', 'M', 'L', 'XL'],
    description: 'Updated description',
  );

  test('should update product successfully', () async {
    // arrange
    mockProductRepository.setShouldSucceed(true);

    // act
    final result = await usecase(UpdateProductParams(testProduct));

    // assert
    expect(result, const Right(null));
    expect(mockProductRepository.lastUpdatedProduct, testProduct);
  });

  test('should return failure when product update fails', () async {
    // arrange
    mockProductRepository.setShouldSucceed(false);

    // act
    final result = await usecase(UpdateProductParams(testProduct));

    // assert
    expect(result, Left(ServerFailure('Failed to update product')));
    expect(mockProductRepository.lastUpdatedProduct, testProduct);
  });
} 