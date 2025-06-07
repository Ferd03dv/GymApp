// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'package:provider/provider.dart';

class CustomErrorMessage extends StatelessWidget {
  final String message;
  final String userId;

  const CustomErrorMessage(
      {super.key, required this.message, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static Future<void> show(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showWithOption(BuildContext context, String message,
      String userRole, String email, String userId) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (userRole == 'Admin') {
                  await userProvider.deleteUserAdminMongoDB(
                      context, email, userId);
                } else {
                  await userProvider.deleteUserAccountMongoDB(context);
                }
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
