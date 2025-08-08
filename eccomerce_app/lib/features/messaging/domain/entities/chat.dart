import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';

class Chat {
   final String id;
  final List<User> participants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });





}