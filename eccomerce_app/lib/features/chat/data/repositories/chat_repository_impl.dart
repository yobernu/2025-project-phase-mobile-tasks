import 'dart:async';
import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_local_data_source.dart';
import '../services/socket_service.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final SocketService socketService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.socketService,
  });

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    if (await networkInfo.isConnected) {
      try {
        final chatModels = await remoteDataSource.getChats();
        await localDataSource.cacheChats(chatModels);
        return Right(chatModels.map((model) => model.toEntity()).toList());
      } catch (e) {
        try {
          final cachedChats = await localDataSource.getCachedChats();
          return Right(cachedChats.map((model) => model.toEntity()).toList());
        } catch (cacheException) {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedChats = await localDataSource.getCachedChats();
        return Right(cachedChats.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final chatModel = await remoteDataSource.getChatById(chatId);
        await localDataSource.cacheChatById(chatId, chatModel);
        return Right(chatModel.toEntity());
      } catch (e) {
        try {
          final cachedChat = await localDataSource.getCachedChatById(chatId);
          if (cachedChat != null) {
            return Right(cachedChat.toEntity());
          } else {
            return Left(CacheFailure());
          }
        } catch (cacheException) {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedChat = await localDataSource.getCachedChatById(chatId);
        if (cachedChat != null) {
          return Right(cachedChat.toEntity());
        } else {
          return Left(CacheFailure());
        }
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final messageModels = await remoteDataSource.getChatMessages(chatId);
        await localDataSource.cacheMessages(chatId, messageModels);
        return Right(messageModels.map((model) => model.toEntity()).toList());
      } catch (e) {
        try {
          final cachedMessages = await localDataSource.getCachedMessages(
            chatId,
          );
          return Right(
            cachedMessages.map((model) => model.toEntity()).toList(),
          );
        } catch (cacheException) {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedMessages = await localDataSource.getCachedMessages(chatId);
        return Right(cachedMessages.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final chatModel = await remoteDataSource.initiateChat(userId);
        await localDataSource.cacheChatById(chatModel.id, chatModel);
        return Right(chatModel.toEntity());
      } catch (e, stackTrace) {
        dev.log('Initiate chat failed: $e', stackTrace: stackTrace);
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteChat(chatId);
        // Remove from local cache as well
        final cachedChats = await localDataSource.getCachedChats();
        final updatedChats = cachedChats
            .where((chat) => chat.id != chatId)
            .toList();
        await localDataSource.cacheChats(updatedChats);
        return const Right(unit);
      } catch (e, st) {
        dev.log('sendMessage repo error: $e', stackTrace: st);
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    // Socket-first implementation (backend send endpoint is unreliable)
    try {
      // Attempt to get cached chat to determine current user as sender
      final cachedChat = await localDataSource.getCachedChatById(chatId);
      final senderModel = cachedChat?.user1 ??
          UserModel(id: 'me', name: 'Me', email: 'me@example.com');

      // Map string type to MessageType
      final msgType = () {
        switch (type.toLowerCase()) {
          case 'image':
            return MessageType.image;
          case 'file':
            return MessageType.file;
          default:
            return MessageType.text;
        }
      }();

      final provisional = MessageModel(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        sender: senderModel,
        chatId: chatId,
        content: content,
        type: msgType,
        createdAt: DateTime.now(),
      );

      // Cache optimistically
      await localDataSource.addCachedMessage(chatId, provisional);

      // Emit via socket for real-time delivery
      try {
        socketService.sendMessage(chatId: chatId, content: content, type: type);
      } catch (e) {
        dev.log('Socket send failed: $e');
      }

      return Right(provisional.toEntity());
    } catch (e, st) {
      dev.log('sendMessage (socket-only) failed: $e', stackTrace: st);
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Message> get messageStream {
    return socketService.messageStream.map(
      (messageModel) => messageModel.toEntity(),
    );
  }

  @override
  Future<void> connectToRealTime() async {
    await socketService.connect();
  }

  @override
  Future<void> disconnectFromRealTime() async {
    await socketService.disconnect();
  }
}
