import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../pages/chat_home_screen.dart';
import '../pages/chatting_screen.dart';
import '../../domain/entities/chat.dart';
import '../../injection_container.dart' as chat_di;

class ChatNavigation {
  static const String chatHomeRoute = '/';
  static const String chattingRoute = '/chat-list-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => chat_di.sl<ChatBloc>(),
            child: const ChatScreen(),
          ),
        );

      case chattingRoute:
        final args = settings.arguments as Chat?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => chat_di.sl<ChatBloc>(),
              child: MessageScreen(chat: args),
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
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }

  // Helper methods for navigation
  static void navigateToChatHome(BuildContext context) {
    Navigator.pushNamed(context, chatHomeRoute);
  }

  static void navigateToChat(BuildContext context, {required Chat chat}) {
    Navigator.pushNamed(context, chattingRoute, arguments: chat);
  }
}
