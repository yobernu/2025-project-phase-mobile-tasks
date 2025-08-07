import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases.dart/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class LoginParams extends Params {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
  
}

class LoginUseCase extends UseCase<User, LoginParams> {
  final UserRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.logIn(email: params.email, password: params.password);
  }
}