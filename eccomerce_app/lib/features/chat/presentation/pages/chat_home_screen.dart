import 'package:ecommerce_app/features/chat/presentation/pages/helpers/cards_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/chat.dart';
import 'chatting_screen.dart';
import '../../../auth/domain/repositories/auth_repositories.dart';
import '../../../auth/domain/entities/auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AllCards allCards = AllCards();
  bool _isLoadingUsers = false;

  @override
  void initState() {
    super.initState();
    // Load chats when screen initializes
    context.read<ChatBloc>().add(LoadChats());
    // Connect to real-time messaging
    context.read<ChatBloc>().add(ConnectToRealTime());
    // Load current user for cards
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      _isLoadingUsers = true;
    });

    try {
      // Get UserRepository from dependency injection
      final userRepository = context.read<UserRepository>();

      // Get current user
      final result = await userRepository.getCurrentUser();

      result.fold(
        (failure) {
          // Handle failure - keep fallback cards
          print('Failed to load current user: ${failure.toString()}');
        },
        (User user) {
          // Add current user to cards - this uses the User import
          allCards.addUser(user);
          setState(() {});
        },
      );
    } catch (e) {
      print('Error loading current user: $e');
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  @override
  void dispose() {
    // Disconnect from real-time messaging
    context.read<ChatBloc>().add(DisconnectFromRealTime());
    super.dispose();
  }

  void _navigateToMessageScreen(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageScreen(chat: chat)),
    );
  }

  void _showInitiateChatDialog(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start New Chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the user ID to start a chat with:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'e.g., 66c730840740f8c2bae904e0',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final userId = userIdController.text.trim();
                if (userId.isNotEmpty) {
                  Navigator.of(context).pop();
                  _initiateNewChat(userId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid user ID'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start Chat'),
            ),
          ],
        );
      },
    );
  }

  void _initiateNewChat(String userId) {
    // Show loading indicator
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Starting new chat...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Add a listener to handle the error state
    context.read<ChatBloc>().stream.listen((state) {
      if (state is ChatError) {
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.red),
        );
      }
    });

    // Trigger the initiate chat event
    context.read<ChatBloc>().add(InitiateNewChat(userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatInitiated) {
          // Hide loading and navigate to the new chat
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat started successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to the new chat
          _navigateToMessageScreen(state.chat);
          // Refresh the chat list
          context.read<ChatBloc>().add(LoadChats());
        } else if (state is ChatError) {
          // Hide loading and show error
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start chat: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ),
        body: Column(
          children: [
            // Stories Section
            Container(
              height: 120,
              color: const Color.fromRGBO(33, 150, 243, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _isLoadingUsers
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: allCards.cards.length,
                            itemBuilder: (context, index) {
                              final card = allCards.cards[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: allCards.storiesCard(
                                  card,
                                  useSegments: index == 0,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            // Chat List Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatsLoaded) {
                      if (state.chats.isEmpty) {
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
                                'No chats yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start a new conversation!',
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
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: state.chats.length,
                        itemBuilder: (context, index) {
                          final chat = state.chats[index];
                          return _buildChatItem(chat);
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
                              'Error: ${state.message}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ChatBloc>().add(LoadChats());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showInitiateChatDialog(context),
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add_comment, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    // Determine the chat partner (assuming current user is user1)
    final chatPartner = chat.user2;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            chatPartner.name.isNotEmpty
                ? chatPartner.name[0].toUpperCase()
                : 'U',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          chatPartner.name.isNotEmpty ? chatPartner.name : 'Unknown User',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          chatPartner.email,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _navigateToMessageScreen(chat),
      ),
    );
  }
}
