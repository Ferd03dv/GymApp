// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 10,
        thickness: 1.2,
        indent: 20,
        endIndent: 20,
        color: Colors.grey);
  }
}
