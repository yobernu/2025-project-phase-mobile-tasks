import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/auth.dart';

class Chat extends Equatable {
  final String id;
  final User user1;
  final User user2;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime? updatedAt;

  const Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    this.unreadCount = 0,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    user1,
    user2,
    lastMessage,
    unreadCount,
    updatedAt,
  ];
}
