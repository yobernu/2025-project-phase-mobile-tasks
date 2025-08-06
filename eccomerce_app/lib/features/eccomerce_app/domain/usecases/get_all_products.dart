import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

// Params class for GetProductById use case
class GetAllProductsParams extends Params {
  
  const GetAllProductsParams();
  
  @override
  List<Object?> get props => [];
}

class GetAllProducts implements UseCase<List<Product>, GetAllProductsParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(GetAllProductsParams params) async {
    return await repository.getAllProducts();
  }
}