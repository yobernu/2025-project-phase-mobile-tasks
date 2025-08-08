import 'dart:convert';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/messaging/data/domain/chat_model.dart';
import 'package:http/http.dart' as http;

abstract class MessageRemoteDataSource {
  Future<ChatModel> createChat({required String user1Id, required String user2Id});
  Future<ChatModel> getChatById({required String chatId});
  Future<List<ChatModel>> getChatsForUser({required String userId});
  Future<void> deleteChat({required String chatId});
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;
  
  MessageRemoteDataSourceImpl({required this.client});

  @override
  Future<ChatModel> createChat({required String user1Id, required String user2Id}) async {
    try {
      // TODO: Replace with actual API endpoint
      final response = await client.post(
        Uri.parse('https://api.example.com/chats'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user1Id': user1Id,
          'user2Id': user2Id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> getChatById({required String chatId}) async {
    try {
      // TODO: Replace with actual API endpoint
      final response = await client.get(
        Uri.parse('https://api.example.com/chats/$chatId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getChatsForUser({required String userId}) async {
    try {
      // TODO: Replace with actual API endpoint
      final response = await client.get(
        Uri.parse('https://api.example.com/chats?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteChat({required String chatId}) async {
    try {
      // TODO: Replace with actual API endpoint
      final response = await client.delete(
        Uri.parse('https://api.example.com/chats/$chatId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
