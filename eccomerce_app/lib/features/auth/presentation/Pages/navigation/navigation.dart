
import 'package:ecommerce_app/features/auth/presentation/Pages/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/sign_up_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/splash_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/home_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';


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
            create: (_) => injector<UserBloc>(),
            child: const SplashScreen(),
          ),
        );
      case '/signup-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<UserBloc>(),
            child: SignUpScreen(),
          ),
        );
      case '/signin-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<UserBloc>(),
            child: SignInScreen(),
          ),
        );
      case '/home-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => injector<UserBloc>(),
            child: HomeScreen(),
          ),
        );
    

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}