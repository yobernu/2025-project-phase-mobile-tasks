import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';

class DeleteChatParams {
  final String chatId;
  DeleteChatParams(this.chatId);
}

class DeleteChatUsecase {
  final ChatRepository repository;

  DeleteChatUsecase(this.repository);

  Future<Either<Failure, Unit>> call(DeleteChatParams params) {
    return repository.deleteChat(chatId: params.chatId);
  }
}