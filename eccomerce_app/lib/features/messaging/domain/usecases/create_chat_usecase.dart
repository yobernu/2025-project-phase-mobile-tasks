import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class CreateChatParams {
  final String userId;

  CreateChatParams({required this.userId});
}

class CreateChatUseCase {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  Future<Either<Failure, Chat>> call(CreateChatParams params) {
    return repository.initiateChat(participantId: params.userId);
  }
}
