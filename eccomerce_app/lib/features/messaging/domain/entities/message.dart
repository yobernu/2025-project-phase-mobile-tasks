import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageStatus status;


  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.status
  });
}