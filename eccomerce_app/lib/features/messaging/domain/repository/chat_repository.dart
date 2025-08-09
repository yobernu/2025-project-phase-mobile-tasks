import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, Chat>> initiateChat({
    required String participantId,
  });

  Future<Either<Failure, List<Chat>>> getMyChats();

  Future<Either<Failure, Chat>> getChatById({
    required String chatId,
  });

  Future<Either<Failure, Unit>> deleteChat({
    required String chatId,
  });

  


}