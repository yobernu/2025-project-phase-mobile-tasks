import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';

enum MessageStatus { sent, delivered, read, pending, pendingRead }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageStatus status;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  Message toEntity() => Message(
    id: id,
    chatId: chatId,
    senderId: senderId,
    content: content,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: status,
  );

  factory MessageModel.fromEntity(Message message) => MessageModel(
    id: message.id,
    chatId: message.chatId,
    senderId: message.senderId,
    content: message.content,
    createdAt: message.createdAt,
    updatedAt: message.updatedAt,
    status: message.status,
  );
}
