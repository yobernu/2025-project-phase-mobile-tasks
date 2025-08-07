import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases.dart/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class SignOutParams extends Params {
  final int id;

  const SignOutParams({
    required this.id
  });

  @override
  List<Object?> get props => [id];
  
}

class SignOutUseCase extends UseCase<void, SignOutParams> {
  final UserRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignOutParams params) async {
    return await repository.signOut(id: params.id);
  }
}