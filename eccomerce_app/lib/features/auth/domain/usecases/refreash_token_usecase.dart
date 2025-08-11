import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class RefreshTokenUseCase {
  final UserRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.refreshToken();
  }
}