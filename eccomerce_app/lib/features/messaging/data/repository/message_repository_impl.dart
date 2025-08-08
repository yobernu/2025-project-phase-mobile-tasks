import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/message_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/message_remote_local_Datasource.dart';
import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_Repository.dart';



class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  final MessageLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final StreamController<Message> _messageStreamController = StreamController.broadcast();

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _setupMessageListener();
  }

  void _setupMessageListener() {
    remoteDataSource.messageStream.listen((messageModel) {
      final message = messageModel.toEntity();
      _messageStreamController.add(message);
      localDataSource.cacheMessage(messageModel);
    });
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final messageModels = await remoteDataSource.getMessages(chatId);
        await localDataSource.cacheMessages(chatId, messageModels);
        return Right(messageModels.map((model) => model.toEntity()).toList());
      } catch (e) {
        try {
          final localMessages = await localDataSource.getCachedMessages(chatId);
          return Right(localMessages.map((model) => model.toEntity()).toList());
        } catch (cacheException) {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localMessages = await localDataSource.getCachedMessages(chatId);
        return Right(localMessages.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String chatId,
    required String content,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(chatId: chatId, content: content);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final pendingMessage = MessageModel(
          id: 'pending-${DateTime.now().millisecondsSinceEpoch}',
          chatId: chatId,
          senderId: 'current_user_id', // Get this from your auth system
          content: content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: MessageStatus.pending,
        );
        
        await localDataSource.cachePendingMessage(pendingMessage);
        return const Right(unit);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Stream<Message> get messageStream => _messageStreamController.stream;

  @override
  Future<Either<Failure, Unit>> markAsRead(String messageId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.markAsRead(messageId);
        await localDataSource.updateMessageStatus(messageId, MessageStatus.read);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.updateMessageStatus(messageId, MessageStatus.pendingRead);
        return const Right(unit);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> resendPendingMessages() async {
    if (await networkInfo.isConnected) {
      try {
        final pendingMessages = await localDataSource.getPendingMessages();
        
        for (final message in pendingMessages) {
          await remoteDataSource.sendMessage(
            chatId: message.chatId,
            content: message.content,
          );
          await localDataSource.removePendingMessage(message.id);
        }
        
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> dispose() {
    return _messageStreamController.close();
  }
}