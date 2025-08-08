import 'dart:convert';
import 'package:ecommerce_app/features/messaging/data/modal/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatModel> chats);
  Future<List<ChatModel>> getCachedChats();
  Future<void> deleteCachedChat(String chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String cachedChatsKey = 'CACHED_CHATS';

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonChats = chats
        .map((chat) => json.encode(chat.toJson()))
        .toList();
    await prefs.setStringList(cachedChatsKey, jsonChats);
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonChats = prefs.getStringList(cachedChatsKey);

    if (jsonChats == null) return [];

    return jsonChats.map((jsonStr) {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      return ChatModel.fromJson(jsonMap);
    }).toList();
  }

  @override
  Future<void> deleteCachedChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonChats = prefs.getStringList(cachedChatsKey);

    if (jsonChats == null) return;

    final updatedChats = jsonChats.where((jsonStr) {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      return jsonMap['id'] != chatId;
    }).toList();

    await prefs.setStringList(cachedChatsKey, updatedChats);
  }

  Future<ChatModel?> getChatById(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonChats = prefs.getStringList(cachedChatsKey);

    if (jsonChats == null) return null;

    for (var jsonStr in jsonChats) {
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);
      if (jsonMap['id'] == chatId) {
        return ChatModel.fromJson(jsonMap);
      }
    }

    return null;
  }
}
