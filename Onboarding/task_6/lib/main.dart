import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home-page.dart';
import 'details-page.dart';
import 'update-page.dart';
import 'search-page.dart';
import 'add-product.dart';
import 'product_manager.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => MyHomePage(),
        '/details': (context) {
          print('[DEBUG] Building DetailsPage route');
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DetailsPage(
            id: args['id'],
            imagePath: args['imagePath'],
            title: args['title'],
            subtitle: args['subtitle'],
            price: args['price'],
            rating: args['rating'],
            sizes: args['sizes'],
            description: args['description'],
          );
        },
        '/update': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UpdatePage(
            id: args['id'],
            imagePath: args['imagePath'],
            title: args['title'],
            subtitle: args['subtitle'],
            price: args['price'],
            rating: args['rating'],
            sizes: args['sizes'],
            description: args['description'],
            
          );
        },
        '/search': (context) => SearchPage(),
        '/add-product': (context) => AddProductPage(),
      },
    );
  }
}