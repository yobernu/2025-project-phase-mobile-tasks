import '../../domain/entities/message.dart';
import 'user_model.dart';

MessageType _parseType(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'text':
      return MessageType.text;
    case 'image':
      return MessageType.image;
    case 'file':
      return MessageType.file;
    default:
      return MessageType.text;
  }
}

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.chatId,
    required super.content,
    required super.type,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chatId'] as String,
      content: json['content'] as String,
      type: _parseType(json['type'] as String),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static String _messageTypeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.file:
        return 'file';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': (sender as UserModel).toJson(),
      'chatId': chatId,
      'content': content,
      'type': _messageTypeToString(type),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      sender: sender,
      chatId: chatId,
      content: content,
      type: type,
      createdAt: createdAt,
    );
  }
}
