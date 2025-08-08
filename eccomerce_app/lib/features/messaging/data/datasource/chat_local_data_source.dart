import 'dart:convert';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/messaging/data/model/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChat(ChatModel chat);
  Future<void> cacheChats(List<ChatModel> chats);
  Future<ChatModel?> getChatById(String chatId);
  Future<List<ChatModel>> getCachedChats();
  Future<void> deleteCachedChat(String chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _cachedChatsKey = 'CACHED_CHATS';
  static const String _lastUpdatedKey = 'CHATS_LAST_UPDATED';

  final SharedPreferences prefs;

  ChatLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheChat(ChatModel chat) async {
    try {
      final chats = await getCachedChats();
      final index = chats.indexWhere((c) => c.id == chat.id);
      if (index >= 0) {
        chats[index] = chat;
      } else {
        chats.add(chat);
      }
      await _saveChats(chats);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    try {
      await _saveChats(chats);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _saveChats(List<ChatModel> chats) async {
    final jsonChats = chats.map((chat) => json.encode(chat.toJson())).toList();
    await prefs.setStringList(_cachedChatsKey, jsonChats);
    await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
  }

  @override
  Future<ChatModel?> getChatById(String chatId) async {
    try {
      final chats = await getCachedChats();
      return chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    try {
      final jsonChats = prefs.getStringList(_cachedChatsKey) ?? [];
      return jsonChats.map((jsonStr) {
        return ChatModel.fromJson(json.decode(jsonStr));
      }).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCachedChat(String chatId) async {
    try {
      final chats = await getCachedChats();
      final updatedChats = chats.where((chat) => chat.id != chatId).toList();
      await _saveChats(updatedChats);
    } catch (e) {
      throw CacheException();
    }
  }
}