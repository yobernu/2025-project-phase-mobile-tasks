import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases.dart/usecases.dart';
import '../repositories/product_repository.dart';

class DeleteProductParams extends Params {
  final int id;
  const DeleteProductParams(this.id);
  
  @override
  List<Object?> get props => [id];
}

class DeleteProduct implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}