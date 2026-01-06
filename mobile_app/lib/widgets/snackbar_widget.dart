import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

class SnackbarWidget {
  static void show(BuildContext context, String message, SnackbarType type) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

