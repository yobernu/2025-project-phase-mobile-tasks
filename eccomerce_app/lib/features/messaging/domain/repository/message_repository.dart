import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, Message>> sendMessage({
    required Message message,
  });
}
