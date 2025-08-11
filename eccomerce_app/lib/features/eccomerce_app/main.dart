// import 'package:flutter/material.dart';
// import 'injection_container.dart' as di;
// import 'presentation/pages/Navigation/navigation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await di.init(); // Your DI setup
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ecommerce App',
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//         fontFamily: 'Poppins',
//       ),
//       initialRoute: '/',
//       onGenerateRoute: Navigation.generateRoute,
//     );
//   }
// }
