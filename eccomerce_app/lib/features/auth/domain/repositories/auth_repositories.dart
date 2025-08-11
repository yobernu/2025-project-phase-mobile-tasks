import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../entities/auth.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> logIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isAuthenticated();
}
