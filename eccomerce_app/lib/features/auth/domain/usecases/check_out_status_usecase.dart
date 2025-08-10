import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class CheckAuthStatusUseCase {
  final UserRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call(NoParams params) async {
    final result = await repository.isAuthenticated();
    return result.fold((failure) => false, (isAuth) => isAuth);
  }
}