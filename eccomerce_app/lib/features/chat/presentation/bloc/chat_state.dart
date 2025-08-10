import 'package:equatable/equatable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatLoaded extends ChatState {
  final Chat chat;

  const ChatLoaded(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatMessagesLoaded extends ChatState {
  final String chatId;
  final List<Message> messages;

  const ChatMessagesLoaded({
    required this.chatId,
    required this.messages,
  });

  @override
  List<Object?> get props => [chatId, messages];
}

class ChatInitiated extends ChatState {
  final Chat chat;

  const ChatInitiated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatDeleted extends ChatState {
  final String chatId;

  const ChatDeleted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessageSent extends ChatState {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class RealTimeConnected extends ChatState {}

class RealTimeDisconnected extends ChatState {}

class NewMessageReceivedState extends ChatState {
  final Message message;

  const NewMessageReceivedState(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
