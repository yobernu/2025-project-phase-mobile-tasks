import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_all_products.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'product_bloc_test.mocks.dart';

// Generate mocks
@GenerateMocks([
  GetAllProducts,
  GetProductById,
  UpdateProduct,
  DeleteProduct,
  InsertProduct,
  InputConverter,
])
void main() {
  late ProductBloc bloc;
  late MockGetAllProducts mockGetAllProducts;
  late MockGetProductById mockGetProductById;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late MockInsertProduct mockInsertProduct;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetAllProducts = MockGetAllProducts();
    mockGetProductById = MockGetProductById();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();
    mockInsertProduct = MockInsertProduct();
    mockInputConverter = MockInputConverter();

    bloc = ProductBloc(
      getAllProductsUsecase: mockGetAllProducts,
      getSingleProductUsecase: mockGetProductById,
      updateProductUsecase: mockUpdateProduct,
      deleteProductUsecase: mockDeleteProduct,
      createProductUsecase: mockInsertProduct,
      inputConverter: mockInputConverter,
    );
  });
  const tProductId = '1';
  const tProduct = Product(
    id: '1',
    name: 'Test Product',
    subtitle: 'Test Subtitle',
    price: 100,
    sizes: ['S', 'M', 'L'],
    description: 'Test Description',
    imageUrl: 'test.jpg',
  );

  tearDown(() {
    bloc.close();
  });

  test('initial state should be InitialState', () {
    expect(bloc.state, isA<InitialState>());
  });

  group('LoadAllProductsEvent', () {
    test(
      'should emit [LoadingState, LoadedAllProductsState] when data is gotten successfully',
      () async {
        when(
          mockGetAllProducts.call(any),
        ).thenAnswer((_) async => Right([tProduct]));

        // assert later
        final expected = [
          const LoadingState(),
          LoadedAllProductsState([tProduct]),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const LoadAllProductsEvent());
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when getting data fails',
      () async {
        // arrange
        when(
          mockGetAllProducts.call(any),
        ).thenAnswer((_) async => const Left(ServerFailure()));

        // assert later
        final expected = [
          const LoadingState(),
          const ErrorState('Server Failure'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const LoadAllProductsEvent());
      },
    );
  });

  group('GetSingleProductEvent', () {
    test(
      'should emit [LoadingState, LoadedSingleProductState] when data is gotten successfully',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductId),
        ).thenReturn(const Right(1));
        when(
          mockGetProductById.call(any),
        ).thenAnswer((_) async => Right(tProduct));

        // assert later
        final expected = [
          const LoadingState(),
          LoadedSingleProductState(tProduct),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetSingleProductEvent(tProductId));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when input is invalid',
      () async {
        // arrange
        when(
          mockInputConverter.stringToUnsignedInteger(tProductId),
        ).thenReturn(const Left(InvalidInputFailure()));

        // assert later
        final expected = [
          const LoadingState(),
          const ErrorState('Invalid Input'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetSingleProductEvent(tProductId));
      },
    );
  });

  group('CreateProductEvent', () {
    test(
      'should emit [LoadingState, LoadedAllProductsState] when product is created successfully',
      () async {
        // arrange
        when(
          mockInsertProduct.call(any),
        ).thenAnswer((_) async => const Right(null));

        // assert later
        final expected = [
          const LoadingState(),
          const LoadedAllProductsState([]),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const CreateProductEvent(tProduct));
      },
    );

    test(
      'should emit [LoadingState, ErrorState] when creation fails',
      () async {
        // arrange
        when(
          mockInsertProduct.call(any),
        ).thenAnswer((_) async => const Left(ServerFailure()));

        // assert later
        final expected = [
          const LoadingState(),
          const ErrorState('Server Failure'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const CreateProductEvent(tProduct));
      },
    );
  });
}
