import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases.dart/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProductParams extends Params {
  final Product product;

  const InsertProductParams(this.product);

  @override
  List<Object?> get props => [product];
}

class InsertProduct implements UseCase<void, InsertProductParams> {
  final ProductRepository repository;

  InsertProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(InsertProductParams params) async {
    return await repository.createProduct(params.product);
  }
}