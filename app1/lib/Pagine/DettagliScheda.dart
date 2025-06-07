// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/CustomErrorMessage.dart';
import 'package:gymfit/CustomItem/CustomNoTrainigButton.dart';
import 'package:gymfit/modelli/Exercise.dart';
import '../CustomItem/CustomGestureDetector.dart';
import '../Pagine/ListViewEsercizi.dart';
import 'package:provider/provider.dart';
import '../CustomItem/BackgroundContainer.dart';
import '../Providers/ExerciseProvider.dart';
import '../Providers/SchedeProvider.dart';

class DettagliScheda extends StatefulWidget {
  final String schedaId;
  final bool flagSchedePredefinite;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController timerController;
  final TextEditingController noteController;
  final bool fromNavBar;
  final String userId;
  final String nomeScheda;
  final String scadenza;
  final String userRole;

  const DettagliScheda({
    super.key,
    required this.schedaId,
    required this.flagSchedePredefinite,
    required this.repsController,
    required this.setsController,
    required this.timerController,
    required this.noteController,
    required this.fromNavBar,
    required this.userId,
    required this.scadenza,
    required this.nomeScheda,
    required this.userRole,
  });

  @override
  _DettagliSchedaState createState() => _DettagliSchedaState();
}

class _DettagliSchedaState extends State<DettagliScheda> {
  final TextEditingController nomeSchedaController = TextEditingController();
  List<Exercise> esercizi = [];
  late ExerciseProvider exerciseProvider;
  late SchedeProvider schedeProvider;
  bool isEditing = false;
  String? schedaPredDB;
  List<String> arrayDiId = [];
  late Future<List<Exercise>> _futureExercises;

  @override
  void initState() {
    super.initState();
    schedeProvider = Provider.of<SchedeProvider>(context, listen: false);

    exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    exerciseProvider.addListener(_providerListener);

    _futureExercises = schedeProvider.fetchExercises(widget.schedaId);
  }

  @override
  void dispose() {
    exerciseProvider.removeListener(_providerListener);
    super.dispose();
  }

  void _providerListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const BackgroundContainer(),
          _buildEserciziList(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final schedeProvider = Provider.of<SchedeProvider>(context);
    return AppBar(
      title: Column(
        children: [
          if (!isEditing) ...[
            GestureDetector(
              onTap: () {
                if (widget.flagSchedePredefinite == true ||
                    widget.userRole == 'Admin') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController tempController =
                          TextEditingController(text: widget.nomeScheda);
                      return AlertDialog(
                        title: Text("Modifica Nome Scheda"),
                        content: TextField(
                          controller: tempController,
                          decoration: InputDecoration(
                              hintText: "Inserisci il nuovo nome"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Annulla"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (tempController.text.isNotEmpty) {
                                await schedeProvider.updateNameScheda(
                                    context,
                                    tempController.text,
                                    widget.schedaId,
                                    widget.userRole,
                                    widget.flagSchedePredefinite);
                                setState(() {
                                  isEditing = false;
                                  nomeSchedaController.text =
                                      tempController.text;
                                });
                              }
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  CustomErrorMessage.show(
                      context, "La scheda non e' modificabile!");
                }
              },
              child: Center(
                child: Text(
                  widget.nomeScheda,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              'Valida fino al: ${widget.scadenza}',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ],
      ),
      centerTitle: true,
      actions: [
        if (widget.flagSchedePredefinite == false || widget.userRole == 'Admin')
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ListViewEsercizi(
                    fromCreaScheda: false,
                    fromExercise: false,
                    fromNavBar: false,
                    exerciseDetails: exerciseProvider.exerciseDetails,
                    schedaId: widget.schedaId,
                    userId: widget.userId,
                    flagFromSchedaPred: widget.flagSchedePredefinite,
                    userRole: widget.userRole,
                    requestId: '',
                    flagUploadScheda: true,
                    parentsId: '',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        IconButton(
          onPressed: () async {
            await Provider.of<SchedeProvider>(context, listen: false)
                .deleteScheda(widget.userId, widget.schedaId, context,
                    widget.userRole, widget.flagSchedePredefinite);
          },
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
        if ((schedaPredDB != 'true' || widget.flagSchedePredefinite == false))
          IconButton(
            onPressed: () async {
              await exerciseProvider.updateExerciseOrder(
                  context, widget.schedaId, esercizi, widget.userRole);
            },
            icon: const Icon(Icons.save, color: Colors.white),
          ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
    );
  }

  // Costruzione della lista degli esercizi
  Widget _buildEserciziList() {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            if (widget.flagSchedePredefinite != true ||
                widget.fromNavBar == true) ...{
              Expanded(
                child: Theme(
                  data: ThemeData(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: FutureBuilder<List<Exercise>>(
                    future: _futureExercises,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Errore: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return NoTrainingButtonWidget(
                          userId: '',
                          userRole: '',
                          textUp: "Nessun esercizio trovato!",
                          textDown: "Clicca sul + per aggiungerne uno!",
                          flag: false,
                        );
                      }

                      final esercizi = snapshot.data!;

                      return ReorderableListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: esercizi.length,
                        itemBuilder: (BuildContext context, int index) {
                          final esercizio = esercizi[index];
                          final esercizioSuperserie =
                              esercizio.superserie ?? {};

                          final Map<Exercise, Map<String, dynamic>>
                              superserieMappa = {
                            for (final entry in esercizioSuperserie.entries)
                              Exercise.fromJson(
                                      Map<String, dynamic>.from(entry.value)):
                                  Map<String, dynamic>.from(entry.value)
                          };

                          return Column(
                            key: ValueKey(esercizio.id),
                            children: [
                              ReorderableDragStartListener(
                                index: index,
                                child: CustomGestureDetector(
                                  index: index,
                                  orderedExercises: [],
                                  exercise: esercizio,
                                  schedaId: widget.schedaId,
                                  flagCreaScheda: false,
                                  setsController: TextEditingController(
                                      text: esercizio.sets),
                                  repsController: TextEditingController(
                                      text: esercizio.reps),
                                  timerController: TextEditingController(
                                      text: esercizio.timer),
                                  pesoController:
                                      TextEditingController(text: ""),
                                  noteController: TextEditingController(
                                      text: esercizio.note),
                                  numRep: esercizio.reps ?? '',
                                  numSet: esercizio.sets ?? '',
                                  timer: esercizio.timer ?? '',
                                  peso: '',
                                  note: esercizio.note ?? '',
                                  schedaPredDB: schedaPredDB,
                                  userRole: widget.userRole,
                                  fromNavBarSchedePred: widget.fromNavBar,
                                  exerciseDetails: const {},
                                  superserie: superserieMappa,
                                  flagUploadScheda: false,
                                ),
                              ),
                            ],
                          );
                        },
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final movedItem = esercizi.removeAt(oldIndex);
                            esercizi.insert(newIndex, movedItem);
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            }
          ],
        );
      },
    );
  }
}
