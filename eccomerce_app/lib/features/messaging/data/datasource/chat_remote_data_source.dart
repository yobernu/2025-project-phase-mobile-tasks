import 'dart:convert';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/messaging/data/model/chat_model.dart';
import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> initiateChat({required String participantId});
  Future<ChatModel> getChatById({required String chatId});
  Future<List<ChatModel>> getUserChats();
  Future<List<MessageModel>> getChatMessages({required String chatId});
  Future<void> deleteChat({required String chatId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  static const String _baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v3';

  ChatRemoteDataSourceImpl({required this.client, required this.prefs});

  Future<Map<String, String>> _getHeaders() async {
    final token = prefs.getString('authToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<ChatModel> initiateChat({required String participantId}) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/chats'),
        headers: await _getHeaders(),
        body: json.encode({'participantId': participantId}),
      );

      if (response.statusCode == 201) {
        return ChatModel.fromJson(json.decode(response.body));
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
      final response = await client.get(
        Uri.parse('$_baseUrl/chats/$chatId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return ChatModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getUserChats() async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/chats'),
        headers: await _getHeaders(),
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
  Future<List<MessageModel>> getChatMessages({required String chatId}) async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/chats/$chatId/messages'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MessageModel.fromJson(json)).toList();
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
      final response = await client.delete(
        Uri.parse('$_baseUrl/chats/$chatId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}