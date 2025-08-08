import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage({required String chatId, required String content});
  Future<void> markAsRead(String messageId);
  Stream<MessageModel> get messageStream;
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;
  final IO.Socket socket;
  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v3';
  
  final StreamController<MessageModel> _messageStreamController = StreamController.broadcast();

  MessageRemoteDataSourceImpl({required this.client, required this.socket}) {
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socket.on('receive_message', (data) {
      try {
        final message = MessageModel.fromJson(data);
        _messageStreamController.add(message);
      } catch (e) {
        print('Error parsing socket message: $e');
      }
    });
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
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
  Future<void> sendMessage({required String chatId, required String content}) async {
    try {
      socket.emit('send_message', {
        'chatId': chatId,
        'content': content,
      });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> markAsRead(String messageId) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/messages/$messageId/read'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Stream<MessageModel> get messageStream => _messageStreamController.stream;
}