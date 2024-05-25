import 'dart:io';

import 'package:flutter/material.dart';

exitAlet(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure you want to leave?'),
      actions: [
        TextButton(
          onPressed: () => exit(0),
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
      ],
    ),
  );
}
