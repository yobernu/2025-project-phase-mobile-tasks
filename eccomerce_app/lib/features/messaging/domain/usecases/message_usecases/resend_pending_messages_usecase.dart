import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class ResendPendingMessagesUseCase extends UseCase<Unit, NoParams> {
  final MessageRepository repository;

  ResendPendingMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.resendPendingMessages();
  }
}