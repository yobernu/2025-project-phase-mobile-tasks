import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<ChatModel> initiateChat(String userId);
  Future<void> deleteChat(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  ChatRemoteDataSourceImpl({required this.client});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        // Add authorization header when available
        // 'Authorization': 'Bearer $token',
      };

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> chatsJson = jsonResponse['data'];
      return chatsJson.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      throw Exception('Failed to get chats');
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ChatModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to get chat by ID');
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> messagesJson = jsonResponse['data'];
      return messagesJson.map((message) => MessageModel.fromJson(message)).toList();
    } else {
      throw Exception('Failed to get chat messages');
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/chats'),
      headers: _headers,
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return ChatModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to initiate chat');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete chat');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: _headers,
      body: json.encode({
        'content': content,
        'type': type,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return MessageModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
