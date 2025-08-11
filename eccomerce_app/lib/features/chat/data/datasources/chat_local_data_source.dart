import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatModel>> getCachedChats();
  Future<void> cacheChats(List<ChatModel> chats);
  Future<ChatModel?> getCachedChatById(String chatId);
  Future<void> cacheChatById(String chatId, ChatModel chat);
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<void> addCachedMessage(String chatId, MessageModel message);
  Future<void> clearCache();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  static const String _chatsKey = 'CACHED_CHATS';
  static const String _chatPrefix = 'CACHED_CHAT_';
  static const String _messagesPrefix = 'CACHED_MESSAGES_';

  @override
  Future<List<ChatModel>> getCachedChats() async {
    final jsonString = sharedPreferences.getString(_chatsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    final jsonString = json.encode(chats.map((chat) => chat.toJson()).toList());
    await sharedPreferences.setString(_chatsKey, jsonString);
  }

  @override
  Future<ChatModel?> getCachedChatById(String chatId) async {
    final jsonString = sharedPreferences.getString('$_chatPrefix$chatId');
    if (jsonString != null) {
      return ChatModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheChatById(String chatId, ChatModel chat) async {
    final jsonString = json.encode(chat.toJson());
    await sharedPreferences.setString('$_chatPrefix$chatId', jsonString);
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final jsonString = sharedPreferences.getString('$_messagesPrefix$chatId');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final jsonString = json.encode(messages.map((message) => message.toJson()).toList());
    await sharedPreferences.setString('$_messagesPrefix$chatId', jsonString);
  }

  @override
  Future<void> addCachedMessage(String chatId, MessageModel message) async {
    final existingMessages = await getCachedMessages(chatId);
    existingMessages.add(message);
    await cacheMessages(chatId, existingMessages);
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    final chatKeys = keys.where((key) => 
        key.startsWith(_chatPrefix) || 
        key.startsWith(_messagesPrefix) || 
        key == _chatsKey
    ).toList();
    
    for (final key in chatKeys) {
      await sharedPreferences.remove(key);
    }
  }
}
