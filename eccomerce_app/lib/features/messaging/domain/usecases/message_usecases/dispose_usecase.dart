
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class DisposeUseCase {
  final MessageRepository repository;

  DisposeUseCase(this.repository);

  void call() {
    repository.dispose();
  }
}