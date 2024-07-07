import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;
  const CustomTextField(
      {super.key,
      required this.text,
      required this.controller,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$text is missing!";
        }
        return null;
      },
    );
  }
}
