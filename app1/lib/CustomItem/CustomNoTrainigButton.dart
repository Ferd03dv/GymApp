// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Pagine/CreaScheda.dart';
import 'package:gymfit/Pagine/TrainerRequestForm.dart';

class NoTrainingButtonWidget extends StatelessWidget {
  final String userId;
  final String userRole;
  final String textUp;
  final String textDown;
  final bool flag;

  const NoTrainingButtonWidget(
      {super.key,
      required this.userId,
      required this.userRole,
      required this.textUp,
      required this.textDown,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textUp,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              textDown,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (flag) ...{
                  ElevatedButton(
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
                    child: const Text(
                      "Crea scheda!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                },
                if (userRole == 'user') ...{
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrainerRequestForm(
                                  userId: userId,
                                  userRole: userRole,
                                  requestId: '',
                                  tipoAllenamento: '',
                                  esperienza: '',
                                  eta: '',
                                  commento: '',
                                  isModified: false,
                                  userIdRequest: '',
                                )),
                      );
                    },
                    child: const Text(
                      "Chiedi al PT!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                }
              ],
            ),
          ],
        ),
      ),
    );
  }
}
