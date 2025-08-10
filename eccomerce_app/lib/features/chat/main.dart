import 'package:flutter/material.dart';
import 'chat_feature.dart';
import 'presentation/navigation/chat_navigation.dart';
import '../auth/injection_container.dart' as auth_di;
import 'injection_container.dart' as chat_di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await auth_di.init();
  await chat_di.initChatFeature();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce Chat App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      onGenerateRoute: ChatNavigation.generateRoute,
    );
  }
}
