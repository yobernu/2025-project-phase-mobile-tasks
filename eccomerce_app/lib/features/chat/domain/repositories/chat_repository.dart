import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  // Get all chats for the current user
  Future<Either<Failure, List<Chat>>> getChats();
  
  // Get a specific chat by ID
  Future<Either<Failure, Chat>> getChatById(String chatId);
  
  // Get messages for a specific chat
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
  
  // Initiate a new chat with another user
  Future<Either<Failure, Chat>> initiateChat(String userId);
  
  // Delete a chat
  Future<Either<Failure, Unit>> deleteChat(String chatId);
  
  // Send a message
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
  
  // Real-time message stream
  Stream<Message> get messageStream;
  
  // Connect to real-time messaging
  Future<void> connectToRealTime();
  
  // Disconnect from real-time messaging
  Future<void> disconnectFromRealTime();
}
