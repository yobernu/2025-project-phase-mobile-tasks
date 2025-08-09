abstract class ChatEvent {
  const ChatEvent();
}

class LoadChatsEvent extends ChatEvent {
  const LoadChatsEvent();
}

class CreateChatEvent extends ChatEvent {
  final String user1Id;
  final String user2Id;
  
  const CreateChatEvent(this.user1Id, this.user2Id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateChatEvent &&
          runtimeType == other.runtimeType &&
          user1Id == other.user1Id &&
          user2Id == other.user2Id;

  @override
  int get hashCode => user1Id.hashCode ^ user2Id.hashCode;
}

class GetChatByIdEvent extends ChatEvent {
  final String chatId;
  
  const GetChatByIdEvent(this.chatId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetChatByIdEvent &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId;

  @override
  int get hashCode => chatId.hashCode;
}

class GetChatsForUserEvent extends ChatEvent {
  final String userId;
  
  const GetChatsForUserEvent(this.userId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetChatsForUserEvent &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

class GetMessagesEvent extends ChatEvent {
  final String chatId;
  
  const GetMessagesEvent(this.chatId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetMessagesEvent &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId;

  @override
  int get hashCode => chatId.hashCode;
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;
  
  const SendMessageEvent(this.chatId, this.content);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendMessageEvent &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId &&
          content == other.content;

  @override
  int get hashCode => chatId.hashCode ^ content.hashCode;
}

class MarkAsReadEvent extends ChatEvent {
  final String messageId;
  
  const MarkAsReadEvent(this.messageId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkAsReadEvent &&
          runtimeType == other.runtimeType &&
          messageId == other.messageId;

  @override
  int get hashCode => messageId.hashCode;
}

class ResendPendingMessagesEvent extends ChatEvent {
  const ResendPendingMessagesEvent();
}

class DisposeEvent extends ChatEvent {
  const DisposeEvent();
}