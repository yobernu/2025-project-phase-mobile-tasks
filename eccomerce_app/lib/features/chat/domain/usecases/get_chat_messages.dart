import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages implements UseCase<List<Message>, String> {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(String chatId) async {
    return await repository.getChatMessages(chatId);
  }
}
