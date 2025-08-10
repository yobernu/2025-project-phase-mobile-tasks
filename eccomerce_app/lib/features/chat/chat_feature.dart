import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as chat_di;
import 'presentation/bloc/chat_bloc.dart';
import 'presentation/pages/chat_list_page.dart';

/// Main entry point for the Chat feature
/// This class provides easy integration with your main app
class ChatFeature {
  static bool _initialized = false;

  /// Initialize the chat feature dependencies
  static Future<void> initialize() async {
    if (!_initialized) {
      await chat_di.initChatFeature();
      _initialized = true;
    }
  }

  /// Get the main chat page wrapped with BlocProvider
  static Widget getChatPage() {
    if (!_initialized) {
      throw Exception('ChatFeature must be initialized before use. Call ChatFeature.initialize() first.');
    }

    return BlocProvider(
      create: (context) => chat_di.sl<ChatBloc>(),
      child: const ChatListPage(),
    );
  }

  /// Get a chat page with custom BlocProvider for more control
  static Widget getChatPageWithCustomBloc(ChatBloc chatBloc) {
    return BlocProvider.value(
      value: chatBloc,
      child: const ChatListPage(),
    );
  }

  /// Create a new ChatBloc instance
  static ChatBloc createChatBloc() {
    if (!_initialized) {
      throw Exception('ChatFeature must be initialized before use. Call ChatFeature.initialize() first.');
    }
    return chat_di.sl<ChatBloc>();
  }
}

/// Example integration widget showing how to use the chat feature
class ChatIntegrationExample extends StatefulWidget {
  const ChatIntegrationExample({Key? key}) : super(key: key);

  @override
  State<ChatIntegrationExample> createState() => _ChatIntegrationExampleState();
}

class _ChatIntegrationExampleState extends State<ChatIntegrationExample> {
  bool _isInitialized = false;
  String _initializationError = '';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await ChatFeature.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _initializationError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized && _initializationError.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Chat Feature...'),
            ],
          ),
        ),
      );
    }

    if (_initializationError.isNotEmpty) {
      return Scaffold(
        body: Center(
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
                'Failed to initialize chat feature',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _initializationError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _initializationError = '';
                  });
                  _initializeChat();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return ChatFeature.getChatPage();
  }
}
