import '../../domain/entities/message.dart';
import 'user_model.dart';
import 'chat_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.chat,
    required super.content,
    required super.type,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chat: ChatModel.fromJson(json['chat'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: _parseMessageType(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  static MessageType _parseMessageType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return MessageType.text;
      default:
        return MessageType.text;
    }
  }

  static String _messageTypeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': (sender as UserModel).toJson(),
      'chat': (chat as ChatModel).toJson(),
      'content': content,
      'type': _messageTypeToString(type),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      sender: sender,
      chat: chat,
      content: content,
      type: type,
      createdAt: createdAt,
    );
  }
}
