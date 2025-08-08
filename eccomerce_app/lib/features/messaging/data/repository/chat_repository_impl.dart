import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Chat>> initiateChat({required String participantId}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.initiateChat(participantId: participantId);
        await localDataSource.cacheChat(chat);
        return Right(chat.toEntity());
      } on ServerException catch (_) {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById({required String chatId}) async {
    try {
      // Try local first
      final localChat = await localDataSource.getChatById(chatId);
      if (localChat != null) {
        return Right(localChat.toEntity());
      }

      // Fallback to remote if connected
      if (await networkInfo.isConnected) {
        try {
          final remoteChat = await remoteDataSource.getChatById(chatId: chatId);
          await localDataSource.cacheChat(remoteChat);
          return Right(remoteChat.toEntity());
        } on ServerException catch (_) {
          return Left(ServerFailure());
        }
      }

      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getUserChats() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteChats = await remoteDataSource.getUserChats();
          await localDataSource.cacheChats(remoteChats);
          return Right(remoteChats.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          // Fallback to cache if remote fails
          final localChats = await localDataSource.getCachedChats();
          if (localChats.isNotEmpty) {
            return Right(localChats.map((model) => model.toEntity()).toList());
          }
          return Left(ServerFailure());
        }
      } else {
        final localChats = await localDataSource.getCachedChats();
        if (localChats.isNotEmpty) {
          return Right(localChats.map((model) => model.toEntity()).toList());
        }
        return Left(CacheFailure());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChat({required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteChat(chatId: chatId);
        await localDataSource.deleteCachedChat(chatId);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() {
    // TODO: implement getMyChats
    throw UnimplementedError();
  }
}