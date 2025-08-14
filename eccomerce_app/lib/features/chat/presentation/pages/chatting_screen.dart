import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = '/message-screen';

  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Chat? chat;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  // Cache last known messages to avoid spinner on non-message states
  List<Message> _messages = const [];
  String? _messagesChatId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chat == null) {
      _initializeChat();
    }
    // Ensure real-time is connected when entering the screen
    context.read<ChatBloc>().add(ConnectToRealTime());
  }

  void _initializeChat() {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Chat) {
      chat = routeArgs;
    } else if (routeArgs is Map<String, dynamic>) {
      chat = routeArgs['chat'] as Chat?;
    }

    if (chat != null) {
      // Avoid HTTP fetch; show empty/cached immediately
      context.read<ChatBloc>().add(ShowChatMessagesEmpty(chat!.id));
    } else {
      Navigator.of(context).pop();
      _showErrorSnackbar('Failed to load chat');
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty || chat == null || _isSending) return;

    setState(() => _isSending = true);
    // Debug: log the chat and users at send time
    dev.log(
      '[MessageScreen] SEND -> using chatId=${chat!.id}, '
      'user1=${chat!.user1.id}, user2=${chat!.user2.id}, contentLen=${content.length}',
    );
    context.read<ChatBloc>().add(
      SendMessageEvent(chatId: chat!.id, content: content, type: 'text'),
    );
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chat == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageSent) {
          setState(() => _isSending = false);
          // Debug: compare chat ids and user ids
          dev.log(
            '[MessageScreen] MESSAGE_SENT -> screen.chatId=${chat?.id}, '
            'returned.chatId=${state.message.chatId}',
          );
          dev.log(
            '[MessageScreen] USERS -> screen.user1=${chat?.user1.id}, '
            'screen.user2=${chat?.user2.id}, message.sender=${state.message.sender.id}',
          );

          // Skip HTTP-based realignment while backend is down
        } else if (state is ChatMessagesLoaded) {
          // Store latest messages locally for stable rendering
          setState(() {
            _messagesChatId = state.chatId;
            _messages = state.messages;
          });
        } else if (state is ChatError) {
          _showErrorSnackbar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(child: _buildMessageList(state)),
              _buildMessageInput(),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(child: Text(chat!.user2.name[0])),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chat!.user2.name),
              const Text('Online', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
      ],
    );
  }

  Widget _buildMessageList(ChatState state) {
    // Only show spinner when specifically loading messages
    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final messages = _messages;
    if (_messagesChatId == null || messages.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    if (state is ChatError) {
      return Center(child: Text(state.message));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.sender.id == chat!.user1.id;
    final isPending = message.id.startsWith('temp-');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            if (isMe) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isPending)
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isMe ? Colors.white70 : Colors.black38,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.check,
                      size: 14,
                      color: isMe ? Colors.white70 : Colors.black45,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
