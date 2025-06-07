// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? firstAction;
  final IconData icon;
  final IconData? secondIcon;
  final String? title;
  final void Function()? secondAction;

  const MyAppBar({
    required this.firstAction,
    required this.icon,
    this.secondIcon,
    this.title,
    this.secondAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: firstAction,
        icon: Icon(icon),
        color: Colors.white,
      ),
      title: title != null
          ? Text(
              title!,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          : null,
      centerTitle: true,
      actions: [
        if (secondIcon != null && secondAction != null)
          IconButton(
            onPressed: secondAction,
            icon: Icon(secondIcon),
            color: Colors.white,
          ),
      ],
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
