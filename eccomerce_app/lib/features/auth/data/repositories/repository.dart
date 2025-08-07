import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_local_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteAuthDataSource remote;
  final LocalAuthDataSource local;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({required this.remote, required this.local, required this.networkInfo});

  @override
Future<Either<Failure, User>> signUp({
  required String name,
  required String email,
  required String password,
}) async {
  print('Starting signUp process...'); // Debug log
  final isConnected = await networkInfo.isConnected;
  print('Network connection check: $isConnected'); // Debug log

  // Test the connection checker directly
  try {
    final testConnection = await networkInfo.isConnected;
    print('Direct network test: $testConnection');
  } catch (e) {
    print('Network test error: $e');
  }

  if (!isConnected) {
    print('No internet connection detected'); // Debug log
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    print('Attempting to register user...'); // Debug log
    final user = await remote.register(name, email, password);
    await local.cacheUser(user);
    print('User registered successfully'); // Debug log
    return Right(user);
  } on ServerException catch (_) {
    print('Server exception occurred'); // Debug log
    return Left(ServerFailure());
  } catch (e) {
    print('Other exception: $e'); // Debug log
    return Left(ServerFailure(e.toString()));
  }
}
  
  @override
Future<Either<Failure, User>> logIn({
  required String email,
  required String password,
}) async {
  final isConnected = await networkInfo.isConnected;

  if (!isConnected) {
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    final user = await remote.login(email, password);
    await local.cacheUser(user);
    return Right(user);
  } on ServerException catch (_) {
    return Left(ServerFailure());
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

@override
Future<Either<Failure, void>> signOut({required int id}) async {
  final isConnected = await networkInfo.isConnected;

  if (!isConnected) {
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    await remote.logout(id);
    await local.clearUser();
    return const Right(null);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

}