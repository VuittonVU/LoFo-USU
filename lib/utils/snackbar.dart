import 'package:flutter/material.dart';

class LofoSnack {
  static void show(
      BuildContext context,
      String message, {
        bool error = false,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
