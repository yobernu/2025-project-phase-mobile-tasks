import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class CreateChatParams {
  final String user1Id;
  final String user2Id;

  CreateChatParams({required this.user1Id, required this.user2Id});
}

class CreateChatUseCase {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  Future<Either<Failure, Chat>> call(CreateChatParams params) {
    return repository.createChat(
      user1Id: params.user1Id,
      user2Id: params.user2Id,
    );
  }
}
