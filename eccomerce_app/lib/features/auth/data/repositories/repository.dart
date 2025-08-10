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
  final isConnected = await networkInfo.isConnected;

  if (!isConnected) {
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    final user = await remote.register(name, email, password);
    await local.cacheUser(user);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
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

    // Optional: cache token only, since user info is minimal
    await local.cacheUser(user);

    return Right(user);
  } on ServerException {
    return Left(ServerFailure());
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
@override
Future<Either<Failure, void>> signOut({required String id}) async {
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

  @override
Future<Either<Failure, User>> getCurrentUser() async {
  try {
    final user = await local.getCachedUser();
    if (user != null) {
      return Right(user);
    } else {
      return Left(CacheFailure('No cached user found'));
    }
  } catch (e) {
    return Left(CacheFailure('Failed to retrieve cached user'));
  }
}
  @override
Future<Either<Failure, bool>> isAuthenticated() async {
  try {
    final token = await local.getAccessToken();
    final isValid = token != null && token.isNotEmpty;
    return Right(isValid);
  } catch (e) {
    return Left(CacheFailure('Failed to check authentication status'));
  }
}

 @override
Future<Either<Failure, String>> refreshToken() async {
  if (!await networkInfo.isConnected) {
    return Left(ServerFailure('No internet connection'));
  }

  try {
    final refreshToken = await local.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return Left(CacheFailure('No refresh token available'));
    }

    final newToken = await remote.refreshToken(refreshToken);
    await local.saveAccessToken(newToken);
    return Right(newToken);
  } catch (e) {
    return Left(ServerFailure('Failed to refresh token'));
  }
}

}