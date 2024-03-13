import 'package:flutter/material.dart';

class MyFunctions {
  String firstLetterUpperCase(String text) {
    return (text.substring(0, 1).toUpperCase() + text.substring(1));
  }

  showModal(Widget modal, BuildContext context, {bool barrierDismiss = true}) {
    return showDialog<void>(
      context: context,
      builder: (context) => modal,
      barrierDismissible: barrierDismiss,
    );
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.vertical,
        closeIconColor: Colors.red,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
