import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketManager {
  static IO.Socket? socket;
  
  static Future<void> initSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    
    socket = IO.io(
      'https://g5-flutter-learning-path-be.onrender.com',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .build(),
    );
    
    socket!.onConnect((_) {
      print('Socket connected');
    });
    
    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });
    
    socket!.onError((error) {
      print('Socket error: $error');
    });
  }
  
  static void disconnect() {
    socket?.disconnect();
    socket = null;
  }
  
  static void sendMessage(String chatId, String message) {
    socket?.emit('send_message', {
      'chatId': chatId,
      'message': message,
    });
  }
  
  static void listenForMessages(Function(Map<String, dynamic>) callback) {
    socket?.on('receive_message', (data) {
      callback(data);
    });
  }
  
  static void joinChat(String chatId) {
    socket?.emit('join_chat', {'chatId': chatId});
  }
  
  static void leaveChat(String chatId) {
    socket?.emit('leave_chat', {'chatId': chatId});
  }
}