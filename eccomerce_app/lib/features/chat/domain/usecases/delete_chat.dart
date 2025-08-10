import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteChat implements UseCase<Unit, String> {
  final ChatRepository repository;

  DeleteChat(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String chatId) async {
    return await repository.deleteChat(chatId);
  }
}
