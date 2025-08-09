import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';




class GetChatByIdParams extends Params {
  final String chatId;

  const GetChatByIdParams({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class GetChatByIdUseCase extends UseCase<Chat, GetChatByIdParams> {
  final ChatRepository repository;

  GetChatByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(GetChatByIdParams params) {
    return repository.getChatById(chatId: params.chatId);
  }
}