import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomTextField({
    super.key,
    required this.text,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
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
