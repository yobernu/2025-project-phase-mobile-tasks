import 'injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/providers/bloc/product_bloc.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      home: BlocProvider(
        create: (context) => GetIt.instance<ProductBloc>(),
        child: const HomeScreen(),
      ),
    );
  }
}


