import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/form-input.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/logo_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/Pages/helpers/submit_button.dart';
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
  bool isLoading = false;
  
  // Controllers for form inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (nameController.text.isEmpty || 
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Trigger sign up event
    context.read<UserBloc>().add(
      SignUpRequested(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    // Navigator.pushNamed(context, 'login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up successful!')),
          );
          Navigator.pushReplacementNamed(context, '/signin-screen');
        } else if (state is UserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Scaffold(
          // backgroundColor: Colors.amber,
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
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Spacer(),
                      LogoWidget(fontSize: 18, wsize: 100, hsize: 40),
                    ],
                  ),
                ),

                // create  text
                Text(
                  "Create your account",
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    // fontFamily: Poppins
                  ),
                ),

                SizedBox(height: 20),

                Column(
                    children: [
                      // name input
                      FormInput(
                        title: 'name', 
                        placeholder: 'ex: john smith',
                        controller: nameController,
                      ),

                      // email input
                      FormInput(
                        title: 'email', 
                        placeholder: 'ex: john@example.com',
                        controller: emailController,
                      ),

                      //password input
                      FormInput(
                        title: 'password', 
                        placeholder: 'Enter your password',
                        controller: passwordController,
                        isPassword: true,
                      ),

                      // confirm pass
                      FormInput(
                        title: 'confirm Password',
                        placeholder: 'Confirm your password',
                        controller: confirmPasswordController,
                        isPassword: true,
                      ),
                    ],
                  ),

                SizedBox(height: 30),
                // terms
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),

                      Text("I understood the "),
                      Text(
                        "terms & policy",
                        style: TextStyle(color: Color.fromRGBO(63, 81, 243, 1)),
                      ),
                    ],
                  ),
                ),
                // btn
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return SubmitButton(
                      onPress: state is UserLoading ? null : _handleSignUp, 
                      title: state is UserLoading ? 'SIGNING UP...' : 'SIGN-UP'
                    );
                  },
                ),

                // sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin-screen');
                      }, 
                      child: Text("SIGN-IN", style: TextStyle(color: Color.fromRGBO(63, 81, 243, 1)))
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
