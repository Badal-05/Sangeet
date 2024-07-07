import 'package:flutter/material.dart';

void displaySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message.toString(),
        ),
      ),
    );
}
