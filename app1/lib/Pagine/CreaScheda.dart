// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomGestureDetector.dart';
import 'package:gymfit/CustomItem/CustomAppBar.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/CustomItem/CustomNoTrainigButton.dart';
import 'package:gymfit/Pagine/ListViewEsercizi.dart';
import 'package:gymfit/Providers/ExerciseProvider.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:provider/provider.dart';

class CreaSchedaWidget extends StatefulWidget {
  final Map<Exercise, Map<String, dynamic>> exerciseDetails;
  final bool schedaPredefinita;
  final String userRole;
  final String userId;
  final bool flagRichieste;
  final String userIdRequest;
  final String requestId;

  const CreaSchedaWidget({
    super.key,
    required this.exerciseDetails,
    required this.schedaPredefinita,
    required this.userRole,
    required this.userId,
    required this.flagRichieste,
    required this.userIdRequest,
    required this.requestId,
  });

  @override
  State<CreaSchedaWidget> createState() => _CreaSchedaWidgetState();
}

class _CreaSchedaWidgetState extends State<CreaSchedaWidget> {
  late TextEditingController nameSchedaController;
  late TextEditingController validitaSchedaController;
  late String schedaId = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Timer updateView;
  bool flagCreaScheda = true;

  @override
  void initState() {
    super.initState();

    nameSchedaController = TextEditingController();
    validitaSchedaController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false)
          .setExerciseDetails(widget.exerciseDetails);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        validitaSchedaController.text =
            selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    nameSchedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final schedaProvider = Provider.of<SchedeProvider>(context);
    bool flag = false;

    return MyAppBar(
      firstAction: () {
        Provider.of<ExerciseProvider>(context, listen: false).clearExercises();
        if (widget.userRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: widget.flagRichieste
                        ? widget.userIdRequest
                        : widget.userId,
                    userRole: widget.userRole,
                    email: '',
                  )));
        } else if (widget.userRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: widget.userId,
                    userRole: widget.userRole,
                    email: '',
                  )));
        }
      },
      icon: Icons.close,
      title: 'Nuova Scheda',
      secondIcon: Icons.check,
      secondAction: () async {
        // Verifica se i campi obbligatori sono riempiti
        if (nameSchedaController.text.isEmpty ||
            validitaSchedaController.text.isEmpty) {
          // Mostra un messaggio di errore se i campi sono vuoti
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Per favore, riempi tutti i campi obbligatori.'),
              backgroundColor: Colors.red,
            ),
          );
          return; // Interrompe l'esecuzione del metodo
        }

        if (widget.schedaPredefinita) {
          await Provider.of<SchedeProvider>(context, listen: false)
              .uploadSchedaPredefinita(
            nameSchedaController.text,
            validitaSchedaController.text,
            formKey,
            schedaId,
            widget.exerciseDetails,
            [],
            context,
          )
              .whenComplete(() {
            Provider.of<ExerciseProvider>(context, listen: false)
                .clearExercises();
          });
        } else {
          widget.userRole == 'Admin'
              ? (
                  flag = true,
                  Provider.of<SchedeProvider>(context, listen: false)
                      .uploadScheda(
                    nameSchedaController.text,
                    validitaSchedaController.text,
                    formKey,
                    schedaId,
                    widget.userId,
                    widget.userRole,
                    widget.exerciseDetails,
                    flag,
                    context,
                  )
                      .whenComplete(() {
                    Provider.of<ExerciseProvider>(context, listen: false)
                        .clearExercises();
                    if (widget.requestId != '') {
                      schedaProvider.deleteRequest(context, widget.requestId,
                          widget.userId, widget.userRole);
                    }
                  })
                )
              : await Provider.of<SchedeProvider>(context, listen: false)
                  .uploadScheda(
                  nameSchedaController.text,
                  validitaSchedaController.text,
                  formKey,
                  schedaId,
                  widget.userId,
                  widget.userRole,
                  widget.exerciseDetails,
                  flag,
                  context,
                )
                  .whenComplete(() {
                  Provider.of<ExerciseProvider>(context, listen: false)
                      .clearExercises();
                });
        }
      },
    );
  }

  Widget _buildBody() {
    return Stack(children: [
      const BackgroundContainer(),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: nameSchedaController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelText: 'Inserisci il nome della scheda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: validitaSchedaController,
                readOnly: true, // Impedisce l'inserimento manuale
                onTap: () {
                  _selectDate(context); // Mostra il selettore di date
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelText: 'Inserisci la scadenza',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                onTap: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => ListViewEsercizi(
                              fromNavBar:
                                  widget.schedaPredefinita ? true : false,
                              fromExercise: false,
                              fromCreaScheda: true,
                              exerciseDetails: {},
                              schedaId: '',
                              userId: widget.userId,
                              userRole: widget.userRole,
                              flagFromSchedaPred:
                                  widget.schedaPredefinita ? true : false,
                              requestId: widget.requestId,
                              flagUploadScheda: false,
                              parentsId: '',
                            )),
                  );
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelText: 'Cerca esercizi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.black)),
                ),
              ),
            ),
          ),
          if (widget.exerciseDetails.isEmpty) ...{
            SizedBox(
              height: 100,
            ),
            NoTrainingButtonWidget(
                userId: widget.userId,
                userRole: widget.userRole,
                textUp: widget.userRole == 'user'
                    ? "Hai bisogno di aiuto per una scheda?"
                    : "Inserisci degli esercizi la scheda!",
                textDown: widget.userRole == 'user'
                    ? "Clicca qui per chiedere ad un PT di crearne una!"
                    : "Potrai modificarli in qualsiasi momento!",
                flag: false)
          } else ...{
            Expanded(
              child: Consumer<ExerciseProvider>(
                builder: (context, provider, child) {
                  final orderedExercises = provider.exerciseOrder;

                  return ReorderableListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: orderedExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = orderedExercises[index];

                      final exerciseMap = provider.exerciseDetails[exercise]!;

                      final String reps = exerciseMap['num_reps'];
                      final String sets = exerciseMap['num_sets'];
                      final String peso = exerciseMap['peso'];
                      final String timer = exerciseMap['timer'];
                      final String note = exerciseMap['note'];
                      final Map<Exercise, Map<String, dynamic>> superserie =
                          exerciseMap['superserie'];

                      return Column(
                        key: ValueKey(exercise.id),
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            child: CustomGestureDetector(
                              exercise: exercise,
                              orderedExercises: orderedExercises,
                              index: index,
                              schedaId: '',
                              flagCreaScheda: flagCreaScheda,
                              repsController: TextEditingController(text: reps),
                              setsController: TextEditingController(text: sets),
                              timerController:
                                  TextEditingController(text: timer),
                              pesoController: TextEditingController(text: peso),
                              noteController: TextEditingController(text: note),
                              numRep: reps,
                              numSet: sets,
                              timer: timer,
                              peso: peso,
                              note: note,
                              schedaPredDB: 'false',
                              userRole: widget.userRole,
                              fromNavBarSchedePred: false,
                              exerciseDetails: provider.exerciseDetails,
                              superserie: superserie,
                              flagUploadScheda: false,
                            ),
                          ),
                        ],
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .reorderExercises(oldIndex, newIndex);
                    },
                  );
                },
              ),
            ),
          }
        ],
      ),
    ]);
  }
}
