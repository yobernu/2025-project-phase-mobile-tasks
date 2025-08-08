
import 'dart:convert';
import 'package:ecommerce_app/features/messaging/data/model/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MessageLocalDataSource {
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> cacheMessage(MessageModel message);
  Future<void> cachePendingMessage(MessageModel message);
  Future<List<MessageModel>> getPendingMessages();
  Future<void> removePendingMessage(String messageId);
  Future<void> updateMessageStatus(String messageId, MessageStatus status);
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  static const String cachedMessagesPrefix = 'CACHED_MESSAGES_';
  static const String pendingMessagesKey = 'PENDING_MESSAGES';

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMessages = messages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList('$cachedMessagesPrefix$chatId', jsonMessages);
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMessages = prefs.getStringList('$cachedMessagesPrefix$chatId');
    
    if (jsonMessages == null) return [];
    
    return jsonMessages.map((jsonStr) {
      return MessageModel.fromJson(json.decode(jsonStr));
    }).toList();
  }

  @override
  Future<void> cacheMessage(MessageModel message) async {
    final messages = await getCachedMessages(message.chatId);
    messages.add(message);
    await cacheMessages(message.chatId, messages);
  }

  @override
  Future<void> cachePendingMessage(MessageModel message) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingMessages = await getPendingMessages();
    pendingMessages.add(message);
    
    final jsonMessages = pendingMessages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList(pendingMessagesKey, jsonMessages);
  }

  @override
  Future<List<MessageModel>> getPendingMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMessages = prefs.getStringList(pendingMessagesKey);
    
    if (jsonMessages == null) return [];
    
    return jsonMessages.map((jsonStr) {
      return MessageModel.fromJson(json.decode(jsonStr));
    }).toList();
  }

  @override
  Future<void> removePendingMessage(String messageId) async {
    final pendingMessages = await getPendingMessages();
    final updatedMessages = pendingMessages.where((msg) => msg.id != messageId).toList();
    
    final prefs = await SharedPreferences.getInstance();
    final jsonMessages = updatedMessages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList(pendingMessagesKey, jsonMessages);
  }

  @override
  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update in regular messages
    final keys = prefs.getKeys().where((key) => key.startsWith(cachedMessagesPrefix));
    
    for (final key in keys) {
      final jsonMessages = prefs.getStringList(key);
      if (jsonMessages != null) {
        final updatedMessages = jsonMessages.map((jsonStr) {
          final msg = MessageModel.fromJson(json.decode(jsonStr));
          if (msg.id == messageId) {
            return json.encode(msg.copyWith(status: status).toJson());
          }
          return jsonStr;
        }).toList();
        
        await prefs.setStringList(key, updatedMessages);
      }
    }
    
    // Update in pending messages
    final pendingMessages = await getPendingMessages();
    if (pendingMessages.any((msg) => msg.id == messageId)) {
      final updatedMessages = pendingMessages.map((msg) {
        if (msg.id == messageId) {
          return msg.copyWith(status: status);
        }
        return msg;
      }).toList();
      
      final jsonMessages = updatedMessages.map((msg) => json.encode(msg.toJson())).toList();
      await prefs.setStringList(pendingMessagesKey, jsonMessages);
    }
  }
}