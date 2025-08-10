import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/auth.dart';
import 'chat.dart';

enum MessageType { text }

class Message extends Equatable {
  final String id;
  final User sender;
  final Chat chat;
  final String content;
  final MessageType type;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, sender, chat, content, type, createdAt];
}
