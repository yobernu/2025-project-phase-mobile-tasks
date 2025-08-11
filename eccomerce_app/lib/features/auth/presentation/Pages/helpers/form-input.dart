import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController? controller;
  final bool isPassword;

  const FormInput({
    super.key,
    required this.title,
    required this.placeholder,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.02,
            color: Color.fromRGBO(111, 111, 111, 1),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Color.fromRGBO(136, 136, 136, 1),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.02,
              // fontFamily: Poppins
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),

        SizedBox(height: 15),
      ],
    );
  }
}
