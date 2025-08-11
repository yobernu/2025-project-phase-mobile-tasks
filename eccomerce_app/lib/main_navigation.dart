import 'package:ecommerce_app/features/auth/presentation/Pages/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/sign_up_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/splash_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart'
    as ecommerce;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';

// Import the correct screen widget
const splashScreen = SplashScreen();
const signInScreen = SignInScreen();
const signUpScreen = SignUpScreen();

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final di = GetIt.instance;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => splashScreen);
      case '/signin-screen':
        return MaterialPageRoute(builder: (_) => signInScreen);
      case '/signup-screen':
        return MaterialPageRoute(builder: (_) => signUpScreen);
      case '/home-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<ProductBloc>(),
            child: const ecommerce.HomeScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static String? getInitialRoute() {
    final userBloc = GetIt.instance<UserBloc>();
    final state = userBloc.state;

    if (state is UserLoggedInState) {
      return '/home-screen';
    } else if (state is UserInitialState || state is UserSignedOutState) {
      return '/signin-screen';
    } else if (state is UserFailureState) {
      return '/signin-screen';
    }

    return '/';
  }
}
