import 'package:flutter/material.dart';

AppBar customAppBar({
  required String title,
  required IconData icon,
  required VoidCallback onIconPressed,
}) {
  return AppBar(
    title: Text(title),
    actions: [IconButton(icon: Icon(icon), onPressed: onIconPressed)],
  );
}
