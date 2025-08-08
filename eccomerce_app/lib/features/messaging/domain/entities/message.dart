
import 'package:ecommerce_app/features/messaging/domain/entities/chat.dart';

import '../../../auth/domain/entities/auth.dart';


class Message {
  final String id;
  final User sender;
  final Chat chat;
  final String content;
  final String type; // e.g., "text", "image", "video"

  Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      sender: json['sender'] as User,
      chat: json['chat'] as Chat,
      content: json['content'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'chat': chat,
      'content': content,
      'type': type,
    };
  }
}


enum MessageType { text, image, video }

MessageType parseMessageType(String type) {
  switch (type) {
    case 'text':
      return MessageType.text;
    case 'image':
      return MessageType.image;
    case 'video':
      return MessageType.video;
    default:
      throw ArgumentError('Unknown message type: $type');
  }
}