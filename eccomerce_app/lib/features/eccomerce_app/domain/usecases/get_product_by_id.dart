import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

// Params class for GetProductById use case
class GetProductByIdParams extends Params {
  final int id;
  
  const GetProductByIdParams(this.id);
  
  @override
  List<Object?> get props => [id];
}

class GetProductById implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository repository;

  GetProductById(this.repository);
  
  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) async {
    final result = await repository.getProductById(params.id);
    return result.map((productModel) => productModel as Product);
  }
}