import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Chat>> initiateChat({required String participantId}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remote.initiateChat(participantId: participantId);
        await local.cacheChat(chat);
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
      final localChat = await local.getChatById(chatId);
      if (localChat != null) {
        return Right(localChat.toEntity());
      }

      // Fallback to remote if connected
      if (await networkInfo.isConnected) {
        try {
          final remoteChat = await remote.getChatById(chatId: chatId);
          await local.cacheChat(remoteChat);
          return Right(remoteChat.toEntity());
        } on ServerException catch (_) {
          return Left(ServerFailure());
        }
      }

      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteChats = await remote.getUserChats();
          await local.cacheChats(remoteChats);
          return Right(remoteChats.map((model) => model.toEntity()).toList());
        } on ServerException catch (_) {
          // Fallback to cache if remote fails
          final localChats = await local.getCachedChats();
          if (localChats.isNotEmpty) {
            return Right(localChats.map((model) => model.toEntity()).toList());
          }
          return Left(ServerFailure());
        }
      } else {
        final localChats = await local.getCachedChats();
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
        await remote.deleteChat(chatId: chatId);
        await local.deleteCachedChat(chatId);
        return const Right(unit);
      } on ServerException catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

 
}