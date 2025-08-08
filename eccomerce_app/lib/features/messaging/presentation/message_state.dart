// States
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';

abstract class MessageState {}
class MessageInitial extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  MessageLoaded(this.messages);
}
class MessageSent extends MessageState {}
