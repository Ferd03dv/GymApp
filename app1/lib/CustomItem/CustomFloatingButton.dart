// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Pagine/CreaScheda.dart';

class MyFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final String userId;
  final String userRole;

  const MyFloatingActionButton({
    super.key,
    required this.icon,
    required this.userId,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreaSchedaWidget(
            exerciseDetails: {},
            schedaPredefinita: false,
            userId: userId,
            userRole: userRole,
            flagRichieste: false,
            userIdRequest: '',
            requestId: '',
          ),
        ));
      },
      backgroundColor: Colors.black,
      child: Icon(icon),
    );
  }
}
