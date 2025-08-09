import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class SendMessageParams extends Params {
  final String chatId;
  final String content;

  const SendMessageParams({required this.chatId, required this.content});

  @override
  List<Object?> get props => [chatId, content];
}

class SendMessageUseCase extends UseCase<Unit, SendMessageParams> {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SendMessageParams params) {
    return repository.sendMessage(chatId: params.chatId, content: params.content);
  }
}