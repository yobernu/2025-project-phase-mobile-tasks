// import 'package:ecommerce_app/features/auth/presentation/Pages/navigation/navigation.dart';
// import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';

// import 'injection_container.dart' as di;
// import 'package:flutter/material.dart';

// // main.dart
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await di.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GetIt.instance<UserBloc>(),
//       child: MaterialApp(
//         title: 'Auth App',
//         theme: ThemeData(
//           primaryColor: Color.fromRGBO(63, 81, 243, 1),
//           fontFamily: 'Poppins',
//           textTheme: const TextTheme(
//             // Use Poppins as default
//             bodyLarge: TextStyle(fontFamily: 'Poppins'),
//             bodyMedium: TextStyle(fontFamily: 'Poppins'),
//             bodySmall: TextStyle(fontFamily: 'Poppins'),
//             headlineLarge: TextStyle(fontFamily: 'Poppins'),
//             headlineMedium: TextStyle(fontFamily: 'Poppins'),
//             headlineSmall: TextStyle(fontFamily: 'Poppins'),
//             titleLarge: TextStyle(fontFamily: 'Poppins'),
//             titleMedium: TextStyle(fontFamily: 'Poppins'),
//             titleSmall: TextStyle(fontFamily: 'Poppins'),
//             labelLarge: TextStyle(fontFamily: 'Poppins'),
//             labelMedium: TextStyle(fontFamily: 'Poppins'),
//             labelSmall: TextStyle(fontFamily: 'Poppins'),
//             // Use Caveat Brush for display text (decorative headers)
//             displayLarge: TextStyle(fontFamily: 'CaveatBrush'),
//             displayMedium: TextStyle(fontFamily: 'CaveatBrush'),
//             displaySmall: TextStyle(fontFamily: 'CaveatBrush'),
//           ),
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromARGB(255, 63, 81, 243),
//             primary: const Color.fromARGB(255, 63, 81, 243),
//           ),
//         ),
//         onGenerateRoute: Navigation.generateRoute,
//         initialRoute: '/',
//       ),
//     );
//   }
// }
