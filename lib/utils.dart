import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(
    BuildContext context, {
    String? text,
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text!),
        backgroundColor: color,
      ),
    );
  }
}
