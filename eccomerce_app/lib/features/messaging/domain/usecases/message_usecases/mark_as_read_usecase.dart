import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class MarkAsReadParams extends Params {
  final String messageId;

  const MarkAsReadParams({required this.messageId});
  
  @override
  List<Object?> get props => [messageId];
}

class MarkAsReadUseCase extends UseCase<Unit, MarkAsReadParams> {
  final MessageRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MarkAsReadParams params) {
    return repository.markAsRead(params.messageId);
  }
}