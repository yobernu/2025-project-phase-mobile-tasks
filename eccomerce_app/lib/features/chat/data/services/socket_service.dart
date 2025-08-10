import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';

class SocketService {
  static SocketService? _instance;
  static SocketService get instance => _instance ??= SocketService._internal();
  
  SocketService._internal();

  IO.Socket? _socket;
  final StreamController<MessageModel> _messageController = StreamController<MessageModel>.broadcast();
  
  Stream<MessageModel> get messageStream => _messageController.stream;

  Future<void> connect() async {
    if (_socket?.connected == true) return;

    _socket = IO.io(
      'https://g5-flutter-learning-path-be-tvum.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });

    _socket!.on('newMessage', (data) {
      try {
        final messageModel = MessageModel.fromJson(data);
        _messageController.add(messageModel);
      } catch (e) {
        print('Error parsing message: $e');
      }
    });

    _socket!.onError((error) {
      print('Socket.IO error: $error');
    });
  }

  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void joinChat(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('joinChat', chatId);
    }
  }

  void leaveChat(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('leaveChat', chatId);
    }
  }

  void sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) {
    if (_socket?.connected == true) {
      _socket!.emit('sendMessage', {
        'chatId': chatId,
        'content': content,
        'type': type,
      });
    }
  }

  void dispose() {
    _messageController.close();
    disconnect();
  }
}
