import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';



class GetChatsForUserUseCase extends UseCase<List<Chat>, NoParams> {
  final ChatRepository repository;

  GetChatsForUserUseCase(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) {
    return repository.getMyChats();
  }
}