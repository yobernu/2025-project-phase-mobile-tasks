import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      type: params.type,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String content;
  final String type;

  const SendMessageParams({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [chatId, content, type];
}
