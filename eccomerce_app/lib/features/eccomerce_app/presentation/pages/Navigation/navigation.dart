import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/create_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/details_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/updates_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../domain/entities/product.dart';

final injector = GetIt.instance;

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ProductBloc>(),
            child: const HomeScreen(),
          ),
        );
      case '/product-details':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ProductBloc>(),
            child: DetailsScreen(product: product),
          ),
        );
      case '/product-updates':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ProductBloc>(),
            child: UpdatesScreen(product: product),
          ),
        );
      case '/create-product':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<ProductBloc>(),
            child: CreateScreen(),
            ));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}