import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth.dart';



class SignupUParams extends Params {
  final String name;
  final String email;
  final String password;

  const SignupUParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class SignUpUseCase implements UseCase<User, SignupUParams> {
  final UserRepository repository;

  SignUpUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(SignupUParams params) async {
    return await repository.signUp(name: params.name, email: params.email, password: params.password);
  }
}





