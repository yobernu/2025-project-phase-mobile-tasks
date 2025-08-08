import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;
  final NetworkInfo network;

  ChatRepositoryImpl(this.remote, this.local, this.network);

  @override
  Future<Either<Failure, Chat>> createChat({required String user1Id, required String user2Id}) async {
    try {
      final chatModel = await remote.createChat(user1Id: user1Id, user2Id: user2Id);
      return Right(chatModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Unit>> deleteChat({required String chatId}) async {
    try {
      await remote.deleteChat(chatId: chatId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Chat>> getChatById({required String chatId}) async {
    try {
      final chatModel = await remote.getChatById(chatId: chatId);
      return Right(chatModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  
    @override
  Future<Either<Failure, List<Chat>>> getChatsForUser({required String userId}) async {
    try {
      final chatModels = await remote.getChatsForUser(userId: userId);
      final chats = chatModels.map((model) => model.toEntity()).toList();
      return Right(chats);
    } catch (e) {
      // Optionally log or inspect the error
      return Left(ServerFailure());
    }
  }
}