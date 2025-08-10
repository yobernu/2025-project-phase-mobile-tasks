import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/form-input.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/logo_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/submit_button.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_event.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        dev.log('[SIGN-IN] Missing fields: email="$email", password="$password"');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields')),
        );
        return;
      }

      dev.log('[SIGN-IN] Dispatching LogInRequestedEvent with email="$email"');
      context.read<UserBloc>().add(
        LogInRequestedEvent(email: email, password: password),
      );
    } catch (e, stack) {
      dev.log('[SIGN-IN] Error dispatching login event: $e');
      dev.log('[STACK] $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        dev.log('[SIGN-IN] BlocListener received state: $state');

        if (state is UserLogInSuccessState) {
          dev.log('[SIGN-IN] Login successful for user: ${state.user.email}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign in successful!')),
          );
          Navigator.pushReplacementNamed(context, '/home-screen');
        } else if (state is UserFailureState) {
          dev.log('[SIGN-IN] Login failed: ${state.failure}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: ${state.failure.message ?? state.failure.toString()}')),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(46),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 55),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back),
                    ),
                    Spacer(),
                    LogoWidget(fontSize: 18, wsize: 100, hsize: 40),
                  ],
                ),
              ),

              Text(
                "Sign in to your account",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20),

              Column(
                children: [
                  FormInput(
                    title: 'email',
                    placeholder: 'ex: john@example.com',
                    controller: emailController,
                  ),
                  FormInput(
                    title: 'password',
                    placeholder: 'Enter your password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                ],
              ),

              SizedBox(height: 30),

              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  dev.log('[SIGN-IN] BlocBuilder rendering with state: $state');
                  return SubmitButton(
                    onPress: state is UserLoadingState ? null : _handleSignIn,
                    title: state is UserLoadingState ? 'SIGNING IN...' : 'SIGN-IN',
                  );
                },
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      dev.log('[SIGN-IN] Navigating to /signup-screen');
                      Navigator.pushReplacementNamed(context, '/signup-screen');
                    },
                    child: Text(
                      "SIGN-UP",
                      style: TextStyle(color: Color.fromRGBO(63, 81, 243, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}