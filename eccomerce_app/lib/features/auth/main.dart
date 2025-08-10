import 'package:ecommerce_app/features/auth/presentation/Pages/navigation/navigation.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'injection_container.dart' as di;
import 'package:flutter/material.dart'; 

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<UserBloc>(),
      child: MaterialApp(
        title: 'Auth App',
        theme: ThemeData(
          primaryColor: Colors.blue,
          fontFamily: 'Poppins',
        ),
        onGenerateRoute: Navigation.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
  

