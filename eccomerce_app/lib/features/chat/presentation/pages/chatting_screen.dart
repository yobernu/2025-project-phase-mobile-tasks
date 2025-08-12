import 'package:ecommerce_app/features/chat/presentation/pages/helpers/cards_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'dart:developer' as dev;

class MessageScreen extends StatefulWidget {
  static const String routeName = '/message-screen';

  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Chat? chat;
  bool _isInitialized = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isInitialized = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      // Get chat from route arguments
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      dev.log(
        '[MessageScreen] didChangeDependencies: routeArgs type = '
        '${routeArgs.runtimeType}',
      );

      // Support both passing Chat directly and passing a map {'chat': Chat}
      if (routeArgs is Chat) {
        chat = routeArgs;
      } else if (routeArgs is Map<String, dynamic>) {
        chat = routeArgs['chat'] as Chat?;
      }

      dev.log(
        '[MessageScreen] Resolved chat: id=${chat?.id}, '
        'user1=${chat?.user1.name}, user2=${chat?.user2.name}',
      );

      if (chat != null) {
        _isInitialized = true;
        // Load messages for this chat after the first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (chat != null) {
            dev.log(
              '[MessageScreen] Dispatch LoadChatMessages for chatId='
              '${chat!.id}',
            );
            context.read<ChatBloc>().add(LoadChatMessages(chat!.id));
          } else {
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to load chat')),
              );
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    dev.log(
      '[MessageScreen] _sendMessage called. contentLength='
      '${content.length}, chatId=${chat?.id}',
    );
    if (content.isNotEmpty) {
      dev.log('[MessageScreen] Dispatch SendMessageEvent(chatId=${chat!.id})');
      context.read<ChatBloc>().add(
        SendMessageEvent(chatId: chat!.id, content: content, type: 'text'),
      );
      _messageController.clear();
      dev.log('[MessageScreen] Cleared input after dispatch');
      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          dev.log('[MessageScreen] Requested scroll to bottom');
        }
      });
    } else {
      dev.log('[MessageScreen] _sendMessage ignored: empty content');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chat == null) {
      return const Scaffold(body: Center(child: Text('Chat not found')));
    }
    final chatPartner = chat!.user2; // Assuming user2 is the chat partner

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        dev.log(
          '[MessageScreen] Outer BlocListener state='
          '${state.runtimeType}',
        );
        if (state is MessageSent) {
          if (chat != null) {
            dev.log(
              '[MessageScreen] MessageSent received. Reload messages for '
              'chatId=${chat!.id}',
            );
            context.read<ChatBloc>().add(LoadChatMessages(chat!.id));
          }
        } else if (state is ChatError) {
          dev.log('[MessageScreen] ChatError: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                SizedBox(width: 60, height: 70, child: AllCards().buildCard()),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatPartner.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.call_outlined,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      style: IconButton.styleFrom(iconSize: 30),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.video_call,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      style: IconButton.styleFrom(iconSize: 30),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is MessageSent) {
              if (chat != null) {
                context.read<ChatBloc>().add(LoadChatMessages(chat!.id));
              }
            } else if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              // Messages area
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading messages...'),
                          ],
                        ),
                      );
                    } else if (chat == null) {
                      return const Center(child: Text('Chat not found'));
                    } else if (state is ChatMessagesLoaded &&
                        state.chatId == chat!.id) {
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start the conversation!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return _buildMessageBubble(message);
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading messages',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        'Loading messages...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              // Message input area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Attachment button
                      Transform.rotate(
                        angle: 0.5, // Radians (~-28 degrees)
                        child: IconButton(
                          icon: Icon(
                            Icons.attach_file_rounded,
                            color: Colors.grey.shade600,
                          ),
                          style: IconButton.styleFrom(iconSize: 30),
                          onPressed: () {},
                        ),
                      ),
                      // Message input field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Write your message...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                              // _sendMessage
                              suffixIcon: GestureDetector(
                                onTap: _sendMessage,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(Icons.send),
                                ),
                              ),
                            ),
                            maxLines: null,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Send button
                      BlocListener<ChatBloc, ChatState>(
                        listener: (context, state) {
                          if (state is MessageSent) {
                            // Reload messages after sending
                            if (chat != null) {
                              context.read<ChatBloc>().add(
                                LoadChatMessages(chat!.id),
                              );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,

                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: const Icon(
                                Icons.record_voice_over_rounded,
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    if (chat == null) return const SizedBox.shrink();

    // Determine if message is from current user by comparing with chat users
    // For now, assume user1 is the current user and user2 is the chat partner
    final isFromCurrentUser = message.sender.id == chat!.user1.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                message.sender.name.isNotEmpty
                    ? message.sender.name[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isFromCurrentUser
                        ? Colors.blue
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isFromCurrentUser ? 18 : 4),
                      bottomRight: Radius.circular(isFromCurrentUser ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isFromCurrentUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                message.sender.name.isNotEmpty
                    ? message.sender.name[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
