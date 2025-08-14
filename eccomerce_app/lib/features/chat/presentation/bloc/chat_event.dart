import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Emits an empty ChatMessagesLoaded state (or cached data if you decide to extend handler)
class ShowChatMessagesEmpty extends ChatEvent {
  final String chatId;

  const ShowChatMessagesEmpty(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class LoadChats extends ChatEvent {}

class LoadChatById extends ChatEvent {
  final String chatId;

  const LoadChatById(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class LoadChatMessages extends ChatEvent {
  final String chatId;

  const LoadChatMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class InitiateNewChat extends ChatEvent {
  final String userId;

  const InitiateNewChat(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;

  const DeleteChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;
  final String type;

  const SendMessageEvent({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [chatId, content, type];
}

class ConnectToRealTime extends ChatEvent {}

class DisconnectFromRealTime extends ChatEvent {}

class NewMessageReceived extends ChatEvent {
  final Message message;

  const NewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
