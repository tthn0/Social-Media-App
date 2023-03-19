// Flutter imports:
import 'package:flutter/material.dart';

void alertBox(BuildContext context, String title, String message,
    {Function? action}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (action != null) {
                action();
              }
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
        elevation: 5,
      );
    },
  );
}
