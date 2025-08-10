import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/form-input.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/logo_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/submit_button.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_event.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers for form inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Trigger sign in event
    context.read<UserBloc>().add(
      LogInRequestedEvent(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLogInSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign in successful!')),
          );
          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home-screen');
        } else if (state is UserFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.toString())),
          );
        }
      },
      child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(46),
            child: Column(
              children: [
                // header
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 55),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Spacer(),
                      LogoWidget(fontSize: 18, wsize: 100, hsize: 40),
                    ],
                  ),
                ),

                // sign in text
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
                    // email input
                    FormInput(
                      title: 'email',
                      placeholder: 'ex: john@example.com',
                      controller: emailController,
                    ),

                    // password input
                    FormInput(
                      title: 'password',
                      placeholder: 'Enter your password',
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // button
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return SubmitButton(
                      onPress: state is UserLoadingState ? null : _handleSignIn,
                      title: state is UserLoadingState ? 'SIGNING IN...' : 'SIGN-IN',
                    );
                  },
                ),

                SizedBox(height: 20),

                // bottom - sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
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
