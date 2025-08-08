import 'package:ecommerce_app/features/auth/presentation/Pages/navigation/navigation.dart';

import 'injection_container.dart' as di;
import 'package:flutter/material.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
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


