abstract class MessageEvent {}
class LoadMessages extends MessageEvent {
  final String chatId;
  LoadMessages(this.chatId);
}
class SendMessage extends MessageEvent {
  final String chatId;
  final String senderId;
  final String content;

  SendMessage(this.chatId, this.senderId, this.content);
}

