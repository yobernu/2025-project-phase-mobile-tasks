import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class GetMessageParams extends Params {
  final String chatId;

  const GetMessageParams({required this.chatId});
  
  @override
  List<Object?> get props => [chatId];
}

class GetMessageUseCase extends UseCase<List<Message>, GetMessageParams> {
  final MessageRepository repository;

  GetMessageUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessageParams params) {
    return repository.getMessages(params.chatId);
  }
}