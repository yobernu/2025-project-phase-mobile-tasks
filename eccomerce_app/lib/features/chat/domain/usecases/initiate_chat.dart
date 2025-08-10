import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class InitiateChat implements UseCase<Chat, String> {
  final ChatRepository repository;

  InitiateChat(this.repository);

  @override
  Future<Either<Failure, Chat>> call(String userId) async {
    return await repository.initiateChat(userId);
  }
}
