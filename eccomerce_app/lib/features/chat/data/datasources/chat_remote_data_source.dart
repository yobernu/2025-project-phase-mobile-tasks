import 'dart:convert';
import 'dart:developer' as dev;
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/features/chat/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<ChatModel> initiateChat(String userId, {String? content});
  Future<void> deleteChat(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final AuthService authService;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.authService,
    this.baseUrl =
        "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3",
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = authService.getToken();
    dev.log('Auth token: $token');
    if (token == null) throw Exception('Authentication token is missing');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> chatsJson = jsonResponse['data'] ?? [];
      return chatsJson.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      throw Exception('Failed to get chats: ${response.statusCode}');
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return ChatModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to get chat: ${response.statusCode}');
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> messagesJson = jsonResponse['data'] ?? [];
      return messagesJson.map((msg) => MessageModel.fromJson(msg)).toList();
    } else {
      throw Exception('Failed to get messages: ${response.statusCode}');
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId, {String? content}) async {
    final Uri endpoint = Uri.parse('$baseUrl/chats');

    final Map<String, dynamic> payload = {
      'userId': userId,
      if (content != null) ...{'content': content, 'type': 'text'},
    };

    final response = await client.post(
      endpoint,
      headers: await _getHeaders(),
      body: jsonEncode(payload),
    );

    dev.log('Initiate Chat Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ChatModel.fromJson(data);
    } else {
      throw Exception('Failed to initiate chat: ${response.body}');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete chat: ${response.statusCode}');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    // Backend only supports POST /chats (with userId, content, type)
    // It returns a Chat object. If caller passed a real chatId, resolve
    // the peer userId from that chat (assuming current user is user1).
    final endpoint = Uri.parse('$baseUrl/chats');

    String userIdToMessage = chatId; // treat as peer userId by default
    dev.log(userIdToMessage);
    try {
      // Try resolve chat -> pick user2 as peer (project assumes user1 is self)
      final chat = await getChatById(chatId);
      userIdToMessage = chat.user2.id;
    } catch (_) {
      // Not a chatId or fetch failed; keep provided as userId
    }

    final response = await client.post(
      endpoint,
      headers: await _getHeaders(),
      body: jsonEncode({
        'userId': userIdToMessage,
        'content': content,
        'type': type,
      }),
    );

    dev.log('POST /chats -> ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          final createdChatId = data['_id'] as String?;
          if (createdChatId == null) {
            throw Exception('Missing chat id in response: ${response.body}');
          }
          // Fetch messages of the chat to get the created message (retry few times)
          try {
            List<MessageModel> messages = [];
            for (int i = 0; i < 3; i++) {
              messages = await getChatMessages(createdChatId);
              if (messages.isNotEmpty) break;
              await Future.delayed(const Duration(milliseconds: 250));
            }
            if (messages.isNotEmpty) {
              return messages.last;
            }
          } catch (_) {
            // Ignore fetch errors and synthesize below
          }

          // As a fallback (eventual consistency), synthesize a provisional message
          final user1 = data['user1'] as Map<String, dynamic>?;
          if (user1 == null) {
            throw Exception('No messages yet and missing user1 to synthesize');
          }
          return MessageModel(
            id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
            sender: UserModel.fromJson(user1),
            chatId: createdChatId,
            content: content,
            type: (() {
              switch ((type).toLowerCase()) {
                case 'image':
                  return MessageType.image;
                case 'file':
                  return MessageType.file;
                default:
                  return MessageType.text;
              }
            })(),
            createdAt: DateTime.now(),
          );
        } else {
          throw Exception('Unexpected data type: ${data.runtimeType}');
        }
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }
}
