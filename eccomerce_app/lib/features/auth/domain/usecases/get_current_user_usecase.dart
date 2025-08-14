import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
