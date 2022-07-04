import 'package:flutter/material.dart';

class AlertError extends StatelessWidget {
  final String errorMsg;
  const AlertError({required this.errorMsg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(errorMsg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
