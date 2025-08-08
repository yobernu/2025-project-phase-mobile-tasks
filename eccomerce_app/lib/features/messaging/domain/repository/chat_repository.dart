import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChatsForUser({
    required String userId,
  });

  Future<Either<Failure, Chat>> createChat({
    required String user1Id,
    required String user2Id,
  });

  Future<Either<Failure, Chat>> getChatById({
    required String chatId,
  });

  Future<Either<Failure, Unit>> deleteChat({
    required String chatId,
  });
}