import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/logo_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignUp();
  }

  void _navigateToSignUp() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    if (!mounted) return;
    Navigator.pushNamed(context, '/signup-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/background.png', fit: BoxFit.cover),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(63, 81, 243, 0.5),
                      Theme.of(context).colorScheme.primary,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Your actual content goes here
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(),

                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "ECOMMERCE APP",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          // fontFamily: Poppins,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToSignUp();
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
