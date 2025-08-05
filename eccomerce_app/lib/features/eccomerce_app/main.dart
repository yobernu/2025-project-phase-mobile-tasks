import 'injection_container.dart' as di;
import 'package:flutter/material.dart'; 
import 'presentation/pages/home_screen.dart';


void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: HomeScreen(),
    );
  }
}


