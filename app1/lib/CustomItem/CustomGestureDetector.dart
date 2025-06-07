// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:gymfit/Providers/ExerciseProvider.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:provider/provider.dart';

import 'package:gymfit/Pagine/DettagliEsercizi.dart';

class CustomGestureDetector extends StatelessWidget {
  final Exercise exercise;
  final String schedaId;
  final bool flagCreaScheda;
  final int index;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController timerController;
  final TextEditingController pesoController;
  final TextEditingController noteController;
  final String numSet;
  final String numRep;
  final String timer;
  final String peso;
  final String note;
  final String? schedaPredDB;
  final String userRole;
  final bool fromNavBarSchedePred;
  final Map<Exercise, Map<String, dynamic>> exerciseDetails;
  final List<Exercise> orderedExercises;
  final Map<Exercise, Map<String, dynamic>> superserie;
  final bool flagUploadScheda;

  const CustomGestureDetector({
    super.key,
    required this.index,
    required this.exercise,
    required this.schedaId,
    required this.flagCreaScheda,
    required this.repsController,
    required this.setsController,
    required this.timerController,
    required this.pesoController,
    required this.noteController,
    required this.numSet,
    required this.numRep,
    required this.timer,
    required this.peso,
    required this.note,
    required this.schedaPredDB,
    required this.userRole,
    required this.fromNavBarSchedePred,
    required this.exerciseDetails,
    required this.orderedExercises,
    required this.superserie,
    required this.flagUploadScheda,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DettagliEsercizi(
                exercise: exercise,
                repsController: repsController,
                setsController: setsController,
                timerController: timerController,
                pesoController: pesoController,
                noteController: noteController,
                numRep: numRep,
                numSet: numSet,
                timer: timer,
                peso: peso,
                note: note,
                schedaPredDB: schedaPredDB,
                fromNavBarSchedePred: fromNavBarSchedePred,
                schedaId: schedaId,
                flagPreferiti: false,
                fromCreaScheda: flagCreaScheda,
                fromFirstPage: true,
                exerciseDetails: exerciseDetails,
                fromExercise: false,
                superserie: superserie,
                flagUploadScheda: flagUploadScheda,
              ),
            ));
          },
          child: Card(
            shadowColor: Colors.red,
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      'http://192.168.1.77:3000/gif/${exercise.gifFilename}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 2),
                            Text(
                              ' $numSet x $numRep ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "- timer: $timer'",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Center(
                        child:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ),
                      if (schedaPredDB != 'true' ||
                          fromNavBarSchedePred == true) ...{
                        IconButton(
                          onPressed: () {
                            if (flagCreaScheda) {
                              exerciseProvider.deleteExerciseFromList(
                                index,
                                false,
                              );
                            } else {
                              exerciseProvider.deleteExerciseFromDatabase(
                                  schedaId, exercise.id ?? '');
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.grey),
                        ),
                      }
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomGestureDetectorExercise extends StatelessWidget {
  final int index;
  final List<Exercise> orderedExercise;
  final Exercise esercizio;
  final String exerciseId;
  final String schedaId;
  final String superserieExerciseId;
  final bool flagCreaScheda;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController timerController;
  final TextEditingController pesoController;
  final TextEditingController noteController;
  String numSet;
  String numRep;
  String timer;
  String peso;
  String note;
  final Map<Exercise, Map<String, dynamic>> exerciseDetails;
  bool flagIsSuperSeriePresent;
  bool flagSuperSerie;
  final Map<Exercise, Map<String, dynamic>> superserie;
  final bool flagUploadScheda;

  CustomGestureDetectorExercise({
    super.key,
    required this.index,
    required this.orderedExercise,
    required this.esercizio,
    required this.exerciseId,
    required this.flagCreaScheda,
    required this.repsController,
    required this.setsController,
    required this.timerController,
    required this.pesoController,
    required this.noteController,
    required this.numSet,
    required this.numRep,
    required this.timer,
    required this.peso,
    required this.note,
    required this.schedaId,
    required this.superserieExerciseId,
    required this.exerciseDetails,
    required this.flagIsSuperSeriePresent,
    required this.flagSuperSerie,
    required this.superserie,
    required this.flagUploadScheda,
  });

  void resetFields() {
    repsController.clear();
    setsController.clear();
    timerController.clear();
    pesoController.clear();
    noteController.clear();
    numSet = '';
    numRep = '';
    timer = '';
    peso = '';
    note = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DettagliEsercizi(
                      exercise: esercizio,
                      repsController: repsController,
                      setsController: setsController,
                      timerController: timerController,
                      pesoController: pesoController,
                      noteController: noteController,
                      numRep: numRep,
                      numSet: numSet,
                      timer: timer,
                      peso: peso,
                      note: note,
                      schedaPredDB: '',
                      fromNavBarSchedePred: false,
                      schedaId: schedaId,
                      flagPreferiti: true,
                      fromCreaScheda: flagCreaScheda,
                      fromFirstPage: false,
                      exerciseDetails: exerciseDetails,
                      fromExercise: true,
                      superserie: superserie,
                      flagUploadScheda: flagUploadScheda,
                    )));
          },
          child: Card(
            shadowColor: Colors.red,
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      'http://192.168.1.77:3000/gif/${esercizio.gifFilename}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          esercizio.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 2),
                            Text(
                              ' $numSet x $numRep ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "timer: $timer'",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Center(
                        child:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!flagCreaScheda) {
                            await exerciseProvider.deleteExerciseFromSuperserie(
                              schedaId,
                              exerciseId,
                              superserieExerciseId,
                            );
                          }

                          if (!context.mounted) return;

                          exerciseProvider.deleteExerciseFromList(index, true);
                          resetFields();
                        },
                        icon: const Icon(Icons.delete_forever,
                            color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
