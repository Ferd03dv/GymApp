// ignore_for_file: non_constant_identifier_names, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/CustomErrorMessage.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Pagine/CreaScheda.dart';

class CustomScrollItem {
  Widget MyCustomScrollItem(
      {required BuildContext context,
      required String testo,
      required IconData icon,
      required Color color,
      required String userId,
      required String userRole,
      required String email,
      bool nav = false,
      bool delete = false}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              if (nav == true) {
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
              } else if (delete == true) {
                CustomErrorMessage.showWithOption(
                  context,
                  "Questa azione e' irreversibile. Continuare?",
                  userRole,
                  email,
                  userId,
                ).whenComplete(() {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NavBarAdmin(
                      username: '',
                      currentUserId: '',
                      userRole: userRole,
                      email: '',
                    ),
                  ));
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 0, 0),
                  child: Center(
                    child: Text(
                      testo,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lexend Deca',
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
