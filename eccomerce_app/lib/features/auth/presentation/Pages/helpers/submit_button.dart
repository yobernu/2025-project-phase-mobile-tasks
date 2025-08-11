import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String title;

  const SubmitButton({super.key, this.onPress, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 12, 36, 12),
      child: SizedBox(
        width: double.infinity, // Optional: make it full-width
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(63, 81, 243, 1),
            foregroundColor: Colors.white,
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(title, style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
