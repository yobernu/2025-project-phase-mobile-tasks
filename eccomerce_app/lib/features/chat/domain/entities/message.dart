import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/auth.dart';

enum MessageType { text, image, file }

class Message extends Equatable {
  final String id;
  final User sender;
  final String chatId;
  final String content;
  final MessageType type;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, sender, chatId, content, type, createdAt];
}
