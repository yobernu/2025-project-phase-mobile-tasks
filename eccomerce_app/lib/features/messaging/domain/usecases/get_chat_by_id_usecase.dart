import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class GetChatByIdParams {
  final String chatId;

  GetChatByIdParams({required this.chatId});
}

class GetChatByIdUseCase {
  final ChatRepository repository;

  GetChatByIdUseCase(this.repository);

  Future<Either<Failure, Chat>> call(GetChatByIdParams params) {
    return repository.getChatById(chatId: params.chatId);
  }
}