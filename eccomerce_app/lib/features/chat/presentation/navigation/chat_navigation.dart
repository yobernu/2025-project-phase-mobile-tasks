import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../pages/chat_list_page.dart';
import '../pages/chat_detail_page.dart';
import '../../injection_container.dart' as chat_di;

class ChatNavigation {
  static const String chatListRoute = '/chat';
  static const String chatDetailRoute = '/chat/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chatListRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => chat_di.sl<ChatBloc>(),
            child: const ChatListPage(),
          ),
        );
      
      case chatDetailRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => chat_di.sl<ChatBloc>(),
              child: ChatDetailPage(
                chatId: args['chatId'] as String,
                chatName: args['chatName'] as String,
              ),
            ),
          );
        }
        return _errorRoute();
      
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }

  // Helper methods for navigation
  static void navigateToChatList(BuildContext context) {
    Navigator.pushNamed(context, chatListRoute);
  }

  static void navigateToChatDetail(
    BuildContext context, {
    required String chatId,
    required String chatName,
  }) {
    Navigator.pushNamed(
      context,
      chatDetailRoute,
      arguments: {
        'chatId': chatId,
        'chatName': chatName,
      },
    );
  }
}
