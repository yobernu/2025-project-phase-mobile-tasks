import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';



class DeleteChatParams extends Params {
  final String chatId;
  
  const DeleteChatParams(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class DeleteChatUseCase extends UseCase<Unit, DeleteChatParams> {
  final ChatRepository repository;

  DeleteChatUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteChatParams params) {
    return repository.deleteChat(chatId: params.chatId);
  }
}