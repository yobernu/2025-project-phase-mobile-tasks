import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/product_repository.dart';


class UpdateProductParams extends Params {
  final Product product;

  const UpdateProductParams(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product);
  }
}