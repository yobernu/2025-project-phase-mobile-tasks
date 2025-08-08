import 'dart:convert';
import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';






abstract class MessageLocalDataSource {
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> deleteMessage(String chatId, String messageId);
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  String _keyForChat(String chatId) => 'MESSAGES_$chatId';

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonMessages = messages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList(_keyForChat(chatId), jsonMessages);
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonMessages = prefs.getStringList(_keyForChat(chatId));

    if (jsonMessages == null) return [];

    return jsonMessages.map((jsonStr) {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      return MessageModel.fromJson(jsonMap);
    }).toList();
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonMessages = prefs.getStringList(_keyForChat(chatId));

    if (jsonMessages == null) return;

    final updatedMessages = jsonMessages.where((jsonStr) {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      return jsonMap['id'] != messageId;
    }).toList();

    await prefs.setStringList(_keyForChat(chatId), updatedMessages);
  }


//   Future<void> addMessage(String chatId, MessageModel message) async {
//   final prefs = await SharedPreferences.getInstance();
//   final List<String>? jsonMessages = prefs.getStringList(_keyForChat(chatId)) ?? [];

//   jsonMessages.add(json.encode(message.toJson()));
//   await prefs.setStringList(_keyForChat(chatId), jsonMessages);
// }

}