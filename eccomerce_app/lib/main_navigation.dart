import 'package:ecommerce_app/features/auth/presentation/Pages/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/sign_up_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/splash_screen.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ecommerce_app/features/chat/presentation/pages/chat_home_screen.dart';
import 'package:ecommerce_app/features/chat/presentation/pages/chatting_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/create_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart'
    as ecommerce;
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/details_screen.dart'
    as ecommerce;
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/updates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';

class AuthRoutes {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/signin-screen':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/signup-screen':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
    }
    return null;
  }
}

class ProductRoutes {
  static final di = GetIt.instance;

  static Route<dynamic>? generate(RouteSettings settings) {
    final productBloc = di<ProductBloc>();

    switch (settings.name) {
      case '/home-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productBloc,
            child: const ecommerce.HomeScreen(),
          ),
        );
      case '/product-details':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productBloc,
            child: ecommerce.DetailsScreen(product: product),
          ),
        );
      case '/create-product':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productBloc,
            child: const CreateScreen(),
          ),
        );
      case '/product-updates':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productBloc,
            child: UpdatesScreen(product: product),
          ),
        );
    }
    return null;
  }
}

class ChatRoutes {
  static final di = GetIt.instance;

  static Route<dynamic>? generate(RouteSettings settings) {
    if (settings.name == '/chat-screen') {
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: di<ChatBloc>()),
            BlocProvider.value(value: di<UserBloc>()),
          ],
          child: const ChatScreen(),
        ),
      );
    } else if (settings.name == '/message-screen') {
      final chat = settings.arguments as Chat;
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: di<ChatBloc>()),
            BlocProvider.value(value: di<UserBloc>()),
          ],
          child: const MessageScreen(),
        ),
        settings: RouteSettings(name: settings.name, arguments: {'chat': chat}),
      );
    }
    return null;
  }
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return AuthRoutes.generate(settings) ??
        ProductRoutes.generate(settings) ??
        ChatRoutes.generate(settings) ??
        _undefinedRoute(settings.name);
  }

  static Route<dynamic> _undefinedRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) =>
          Scaffold(body: Center(child: Text('No route defined for $name'))),
    );
  }

  static String getInitialRoute() {
    final state = GetIt.instance<UserBloc>().state;
    if (state is UserLoggedInState) return '/home-screen';
    return '/';
  }
}




















// import 'package:ecommerce_app/features/auth/presentation/Pages/sign_in_screen.dart';
// import 'package:ecommerce_app/features/auth/presentation/Pages/sign_up_screen.dart';
// import 'package:ecommerce_app/features/auth/presentation/Pages/splash_screen.dart';
// import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
// import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
// import 'package:ecommerce_app/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:ecommerce_app/features/chat/presentation/pages/chat_home_screen.dart';
// import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/create_screen.dart';
// import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart'
//     as ecommerce;
// import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
// import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/details_screen.dart'
//     as ecommerce;
// import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/updates_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';

// // Import the correct screen widget
// const splashScreen = SplashScreen();
// const signInScreen = SignInScreen();
// const signUpScreen = SignUpScreen();

// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final di = GetIt.instance;

//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => splashScreen);
//       case '/signin-screen':
//         return MaterialPageRoute(builder: (_) => signInScreen);
//       case '/signup-screen':
//         return MaterialPageRoute(builder: (_) => signUpScreen);
//       case '/home-screen':
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (BuildContext context) => di<ProductBloc>(),
//             child: const ecommerce.HomeScreen(),
//           ),
//         );
//       case '/product-details':
//         final product = settings.arguments as Product;
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (BuildContext context) => di<ProductBloc>(),
//             child: ecommerce.DetailsScreen(product: product),
//           ),
//         );
//       case '/create-product':
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (BuildContext context) => di<ProductBloc>(),
//             child: CreateScreen(),
//           ),
//         );
//       case '/product-updates':
//         final product = settings.arguments as Product;
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (BuildContext context) => di<ProductBloc>(),
//             child: UpdatesScreen(product: product),
//           ),
//         );

//       case '/chat-screen':
//         return MaterialPageRoute(
//           builder: (BuildContext context) => MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (BuildContext context) => di<ChatBloc>()),
//               BlocProvider(create: (BuildContext context) => di<UserBloc>()),
//             ],
//             child: const ChatScreen(),
//           ),
//         );
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }

//   static String? getInitialRoute() {
//     final userBloc = GetIt.instance<UserBloc>();
//     final state = userBloc.state;

//     if (state is UserLoggedInState) {
//       return '/home-screen';
//     } else if (state is UserInitialState || state is UserSignedOutState) {
//       return '/signin-screen';
//     } else if (state is UserFailureState) {
//       return '/signin-screen';
//     }

//     return '/';
//   }
// }
// // in-app navigation