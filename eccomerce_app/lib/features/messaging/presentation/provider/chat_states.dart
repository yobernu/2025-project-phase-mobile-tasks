// States
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';



abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatOperationSuccess extends ChatState {
  final dynamic data;
  const ChatOperationSuccess(this.data);
}
class ChatError extends ChatState {
  final Failure failure;
  
  const ChatError(this.failure);
  
  String get errorMessage => failure.errorMessage;
  
  @override
  List<Object?> get props => [failure];
}

class ChatListLoaded extends ChatState {
  final List<Chat> chats;
  const ChatListLoaded(this.chats);
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  const MessagesLoaded(this.messages);
}