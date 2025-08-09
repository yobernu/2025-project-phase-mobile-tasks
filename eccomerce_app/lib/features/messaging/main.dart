import 'package:ecommerce_app/features/auth/presentation/Pages/navigation/navigation.dart';
import 'package:ecommerce_app/features/messaging/presentation/socket_manager.dart';

import 'injection_container.dart' as message_injection;
import '../auth/injection_container.dart' as user_injection;
import 'package:flutter/material.dart'; 




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await message_injection.init();
  await user_injection.init();
  // await SocketManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Poppins',
      ),
      onGenerateRoute: Navigation.generateRoute,
      initialRoute: '/',
    );
  }
}


