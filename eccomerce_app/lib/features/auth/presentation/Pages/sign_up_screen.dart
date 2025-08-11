import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/logo_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_event.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    // Debug log for form submission attempt
    debugPrint('SignUp attempt initiated');
    debugPrint('Name: ${nameController.text}');
    debugPrint('Email: ${emailController.text}');

    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return;
    }

    if (!isChecked) {
      debugPrint('Terms not accepted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    // Trigger sign up
    debugPrint('Dispatching SignUpRequestedEvent');
    context.read<UserBloc>().add(
      SignUpRequestedEvent(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      debugPrint('Email field empty');
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      debugPrint('Invalid email format: $value');
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      debugPrint('Password field empty');
      return 'Please enter your password';
    }
    if (value.length < 6) {
      debugPrint('Password too short: ${value.length} characters');
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      debugPrint('Password mismatch: $value vs ${passwordController.text}');
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoadingState) {
          debugPrint('SignUp in progress...');
        } else if (state is UserSignUpSuccessState) {
          debugPrint('SignUp successful for user: ${state.user.email}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up successful! Please login.')),
          );
          Navigator.pushReplacementNamed(context, '/signin-screen');
        } else if (state is UserFailureState) {
          debugPrint('SignUp failed: ${state.failure}');
          debugPrint('Stack trace: ${state.failure}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.failure.message ?? 'Sign up failed. Please try again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(46),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 35, 0, 55),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        LogoWidget(fontSize: 18, wsize: 100, hsize: 40),
                      ],
                    ),
                  ),

                  // Title
                  const Text(
                    "Create your account",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  // Form fields
                  Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'ex: john smith',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            debugPrint('Name field empty');
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'ex: john@example.com',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,

                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                        validator: _validateConfirmPassword,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Terms checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          debugPrint('Terms checkbox: ${value ?? false}');
                          setState(() => isChecked = value ?? false);
                        },
                      ),
                      const Text("I understood the "),
                      Text(
                        "terms & policy",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),

                  // Submit button
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: 280,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: state is UserLoadingState
                              ? null
                              : _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is UserLoadingState
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'SIGN UP',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Sign in link
                  TextButton(
                    onPressed: () {
                      debugPrint('Navigating to sign in screen');
                      Navigator.pushReplacementNamed(context, '/signin-screen');
                    },
                    child: const Text("Already have an account? SIGN IN"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
