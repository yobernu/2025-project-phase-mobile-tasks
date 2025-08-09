import 'package:ecommerce_app/features/messaging/presentation/pages/chat/chat_screen.dart';
import 'package:ecommerce_app/features/messaging/presentation/pages/chat/message_screen.dart';
import 'package:ecommerce_app/features/messaging/presentation/provider/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ChatBloc>(),
            child: const ChatScreen(),
            ),
        );
      case '/message-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ChatBloc>(),
            child: MessageScreen(),)
        );
      default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Route not found'),),
        ));
    }
  }
}