import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_all_products.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/insert_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProductsUsecase;
  final GetProductById getSingleProductUsecase;
  final UpdateProduct updateProductUsecase;
  final DeleteProduct deleteProductUsecase;
  final InsertProduct createProductUsecase;
  final InputConverter inputConverter;

  ProductBloc({
    required this.getAllProductsUsecase,
    required this.getSingleProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.createProductUsecase,
    required this.inputConverter,
  }) : super(const InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<CreateProductEvent>(_onCreateProduct);
  }

  void _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    final result = await getAllProductsUsecase.call(
      const GetAllProductsParams(),
    );
    emit(
      result.fold(
        (failure) => ErrorState(_mapFailureToMessage(failure)),
        (products) => LoadedAllProductsState(products),
      ),
    );
  }

  void _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    final inputEither = inputConverter.stringToUnsignedInteger(event.productId);
    await inputEither.fold(
      (failure) async {
        emit(ErrorState(_mapFailureToMessage(failure)));
      },
      (integer) async {
        final result = await getSingleProductUsecase.call(
          GetProductByIdParams(integer.toString()),
        );
        emit(
          result.fold(
            (failure) => ErrorState(_mapFailureToMessage(failure)),
            (product) => LoadedSingleProductState(product),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());

    try {
      // Assuming updateProductUsecase returns Future<Either<Failure, Product>>
      final result = await updateProductUsecase.call(
        UpdateProductParams(event.product),
      );

      result.fold(
        (failure) => emit(ErrorState(_mapFailureToMessage(failure))),
        (_) => emit(const LoadedAllProductsState([])),
      );
    } catch (e) {
      emit(ErrorState('An unexpected error occurred'));
    }
  }

  void _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    final inputEither = inputConverter.stringToUnsignedInteger(event.productId);
    await inputEither.fold(
      (failure) async {
        emit(ErrorState(_mapFailureToMessage(failure)));
      },
      (integer) async {
        final result = await deleteProductUsecase.call(
          DeleteProductParams(integer.toString()),
        );
        await result.fold(
          (failure) async {
            emit(ErrorState(_mapFailureToMessage(failure)));
          },
          (_) async {
            // After successful deletion, reload all products
            final productsResult = await getAllProductsUsecase.call(
              const GetAllProductsParams(),
            );
            emit(
              productsResult.fold(
                (failure) => ErrorState(_mapFailureToMessage(failure)),
                (products) => LoadedAllProductsState(products),
              ),
            );
          },
        );
      },
    );
  }

  void _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    final result = await createProductUsecase.call(
      InsertProductParams(event.product),
    );
    emit(
      result.fold(
        (failure) => ErrorState(_mapFailureToMessage(failure)),
        (_) => const LoadedAllProductsState([]),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return 'Server Failure';
      case CacheFailure():
        return 'Cache Failure';
      case InvalidInputFailure():
        return 'Invalid Input';
      default:
        return 'Unexpected Error';
    }
  }
}
