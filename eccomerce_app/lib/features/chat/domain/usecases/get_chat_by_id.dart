import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChatById implements UseCase<Chat, String> {
  final ChatRepository repository;

  GetChatById(this.repository);

  @override
  Future<Either<Failure, Chat>> call(String chatId) async {
    return await repository.getChatById(chatId);
  }
}
