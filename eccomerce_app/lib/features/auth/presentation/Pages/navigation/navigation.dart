import 'package:ecommerce_app/features/auth/presentation/Pages/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/sign_up_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/splash_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/home_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final injector = GetIt.instance;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => injector<UserBloc>().state is UserAuthenticatedState
              ? const HomeScreen()
              : const SplashScreen(),
        );
      case '/signup-screen':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/signin-screen':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/home-screen':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
