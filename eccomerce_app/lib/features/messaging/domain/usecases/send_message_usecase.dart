import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

import '../entities/message.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(Message message) async {
    await repository.sendMessage(message: message);
  }
}