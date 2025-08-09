import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';




class CreateChatParams extends Params {
  final String userId;

  const CreateChatParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateChatUseCase extends UseCase<Chat, CreateChatParams> {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(CreateChatParams params) {
    return repository.initiateChat(participantId: params.userId);
  }
}