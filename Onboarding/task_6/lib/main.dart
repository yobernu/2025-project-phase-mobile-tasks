import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_product.dart';
import 'details_page.dart';
import 'home_page.dart';
import 'product_manager.dart';
import 'search_page.dart';
import 'update_page.dart';





void main() {
  runApp(
    ChangeNotifierProvider<ProductManager>(
      create: (BuildContext context) => ProductManager(),
      child: const MyApp(),
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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const MyHomePage(),
        '/details': (BuildContext context) {
          dev.log('[DEBUG] Building DetailsPage route');
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
        '/update': (BuildContext context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
        '/search': (BuildContext context) => const SearchPage(),
        '/add-product': (BuildContext context) => const AddProductPage(),
      },
    );
  }
}