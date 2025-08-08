import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, Unit>> sendMessage({
    required String chatId,
    required String content,
  });
  Stream<Message> get messageStream;
  Future<Either<Failure, Unit>> markAsRead(String messageId);
  Future<Either<Failure, Unit>> resendPendingMessages();
  Future<void> dispose();
}