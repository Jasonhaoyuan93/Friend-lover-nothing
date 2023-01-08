import 'package:flutter/material.dart';

//conditionally create alert dialog pop on screen
Future<void> createAlertDialog(context, alertText) async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK', semanticsLabel: "OK",),
          ),
        ],
        content: Text(
          alertText,
          semanticsLabel: alertText,
        ),
        title: const Text('Error', semanticsLabel: "error message",),
      ),
    );
