import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';



class GetChatsForUserUseCase {
  final ChatRepository repository;

  GetChatsForUserUseCase(this.repository);

  Future<Either<Failure, List<Chat>>> call() {
    return repository.getMyChats();
  }
}