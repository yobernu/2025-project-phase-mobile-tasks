import 'package:ecommerce_app/features/auth/data/models/auth_model.dart';
import 'chat_model.dart';
import '../../domain/entities/message.dart';

class MessageModel {
  final String id;
  final UserModel sender;
  final ChatModel chat;
  final String content;
  final String type;

  MessageModel({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: UserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'chat': chat,
      'content': content,
      'type': type
    };
  }

  Message toEntity() => Message(
        id: id,
        sender: sender.toEntity(),
        chat: chat.toEntity(),
        content: content,
        type: type,
      );
}