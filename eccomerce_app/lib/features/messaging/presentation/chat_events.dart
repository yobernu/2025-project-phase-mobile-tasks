abstract class ChatEvent {}
class LoadChats extends ChatEvent {}
class CreateChat extends ChatEvent {
  final String user1Id;
  final String user2Id;
  CreateChat(this.user1Id, this.user2Id);
}
