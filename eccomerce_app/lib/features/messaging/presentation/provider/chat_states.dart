// States
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';

abstract class ChatState {}
class ChatInitial extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Chat> chats;
  ChatLoaded(this.chats);
}
