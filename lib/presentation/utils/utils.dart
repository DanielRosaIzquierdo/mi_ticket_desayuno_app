import 'package:flutter/material.dart';

class PresentationUtils {
  static void showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 20)),
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 40.0, left: 16.0, right: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
