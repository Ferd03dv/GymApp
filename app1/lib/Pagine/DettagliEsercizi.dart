// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, library_private_types_in_public_api, file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../CustomItem/BackgroundContainer.dart';
import '../CustomItem/CustomGestureDetector.dart';
import '../Pagine/ListViewEsercizi.dart';
import '../Providers/ExerciseDetailProvider.dart';
import '../Providers/ExerciseProvider.dart';
import '../modelli/Exercise.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class DettagliEsercizi extends StatefulWidget {
  final Exercise exercise;
  late TextEditingController repsController;
  late TextEditingController setsController;
  late TextEditingController timerController;
  late TextEditingController pesoController;
  late TextEditingController noteController;
  final String numSet;
  final String numRep;
  final String timer;
  final String peso;
  final String note;
  final String? schedaPredDB;
  final bool fromNavBarSchedePred;
  final Map<Exercise, Map<String, dynamic>> exerciseDetails;
  final String schedaId;
  final bool flagPreferiti;
  final bool fromCreaScheda;
  final bool fromExercise;
  final bool fromFirstPage;
  final bool flagUploadScheda;
  final Map<Exercise, Map<String, dynamic>> superserie;

  DettagliEsercizi({
    super.key,
    required this.exercise,
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
    required this.fromNavBarSchedePred,
    required this.schedaId,
    required this.flagPreferiti,
    required this.fromCreaScheda,
    required this.fromFirstPage,
    required this.exerciseDetails,
    required this.fromExercise,
    required this.flagUploadScheda,
    required this.superserie,
  });

  @override
  _DettagliEserciziState createState() => _DettagliEserciziState();
}

class _DettagliEserciziState extends State<DettagliEsercizi> {
  late ExerciseDetailProvider provider;
  late AudioPlayer _audioPlayer;
  final CountDownController _countDownController = CountDownController();
  bool _isPlayingSound = false;
  late Timer updateView;
  bool isLoading = true;
  List<Map<String, dynamic>> esercizi = [];
  List<Exercise> superserieEsercizi = [];
  late ExerciseProvider exerciseProvider;
  bool flagSuperSerie = false;
  bool flagIsSuperSeriePresent = true;
  Map<String, dynamic>? result;
  bool isSuperSerieMessageShown = false;
  int i = 0;

  @override
  void initState() {
    super.initState();
    updateView = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Forza la ricostruzione della UI ogni secondo
        });
      }
    });

    exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    exerciseProvider.addListener(_providerListener);

    _audioPlayer = AudioPlayer();
    provider = ExerciseDetailProvider();
    // Aggiungi un listener per il campo timerController
    widget.timerController.addListener(() {
      final duration = int.tryParse(widget.timerController.text) ?? 0;
      provider.setDuration(Duration(seconds: duration));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false)
          .setSuperSerieExerciseDetails(widget.superserie);
    });
  }

  @override
  void dispose() {
    exerciseProvider.removeListener(_providerListener);
    _audioPlayer.dispose();
    provider.dispose();
    super.dispose();
  }

  void _providerListener() {
    setState(() {});
  }

  /*Future<void> _playTimerEndSound() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/timer.ogg');
      _audioPlayer.play();
      _audioPlayer.setLoopMode(LoopMode.one); // Imposta il suono in loop
      _isPlayingSound = true;
    } catch (error) {
      debugPrint("Errore durante la riproduzione del suono: $error");
    }
  }*/

  void _stopTimerEndSound() {
    if (_isPlayingSound) {
      _audioPlayer.stop();
      _audioPlayer.setLoopMode(LoopMode.off); // Disattiva il loop
      _isPlayingSound = false;
    }
  }

  void _showTimerEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tempo Scaduto'),
          content: const Text('Il tempo è scaduto.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _stopTimerEndSound();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Colore del testo del pulsante
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Center(
          child: Text(
        widget.exercise.name ?? "",
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      )),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          setState(() {
            isSuperSerieMessageShown = false;
          });

          Navigator.pop(context);
        },
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (widget.schedaPredDB != 'true' ||
            widget.fromNavBarSchedePred == true)
          IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                provider.saveData(
                    context,
                    widget.exercise,
                    widget.schedaId,
                    widget.exercise.id ?? '',
                    widget.repsController,
                    widget.setsController,
                    widget.timerController,
                    widget.pesoController,
                    widget.noteController,
                    widget.exerciseDetails,
                    widget.fromCreaScheda,
                    widget.fromExercise,
                    flagSuperSerie,
                    widget.flagUploadScheda);
                Navigator.pop(context);
              }),
      ],
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Consumer<ExerciseDetailProvider>(
      builder: (context, provider, child) {
        // Usa addPostFrameCallback per aggiornare la durata fuori dal processo di build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final duration = int.tryParse(widget.timerController.text) ?? 0;
          if (provider.duration.inSeconds != duration) {
            provider.setDuration(Duration(seconds: duration));
          }
        });

        return Stack(
          children: [
            const BackgroundContainer(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.network(
                          'http://192.168.1.77:3000/gif/${widget.exercise.gifFilename}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        _buildTable(context),
                        const SizedBox(height: 20.0),
                        Center(
                          child: CircularCountDownTimer(
                            duration: provider.duration.inSeconds,
                            initialDuration: 0,
                            controller:
                                _countDownController, // Imposta il controller
                            width: 200,
                            height: 200,
                            ringColor: Colors.grey[300]!,
                            fillColor: const Color.fromARGB(255, 120, 9, 9),
                            backgroundColor: Colors.black,
                            strokeWidth: 10.0,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            isReverse: true,
                            isTimerTextShown: true,
                            autoStart:
                                false, // Non avviare automaticamente, lasciamo che l'utente lo faccia con il pulsante
                            onComplete: () {
                              // Azioni da fare al termine del countdown
                              //_playTimerEndSound();
                              _showTimerEndDialog();
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton('Pausa', Icons.pause, () {
                              _countDownController.pause();
                            }),
                            const SizedBox(width: 16.0),
                            _buildControlButton('Reset', Icons.refresh, () {
                              final currentDuration =
                                  int.tryParse(widget.timerController.text) ??
                                      0;
                              _countDownController.restart(
                                  duration: currentDuration);
                              provider.setDuration(
                                  Duration(seconds: currentDuration));
                            }),
                            const SizedBox(width: 16.0),
                            _buildControlButton('Avvia', Icons.play_arrow, () {
                              // Ottieni la durata aggiornata dal timerController
                              final currentDuration =
                                  int.tryParse(widget.timerController.text) ??
                                      0;

                              // Se il timer è già partito o non è stato impostato correttamente, riavvia il timer con la durata corretta
                              if (_countDownController.isPaused.value) {
                                _countDownController.resume();
                              } else {
                                _countDownController.restart(
                                    duration: currentDuration);
                              }
                            }),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        _buildExerciseDetails(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton(
      String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final exerciseDetail =
        Provider.of<ExerciseProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              columnWidths: {
                0: const FixedColumnWidth(150),
                1: const FlexColumnWidth(),
              },
              border: TableBorder.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
                style: BorderStyle.solid,
              ),
              children: [
                _buildTableRow(
                    'Serie da fare:', widget.setsController, '', 0, 10),
                _buildTableRow(
                    'Ripetizioni:', widget.repsController, '', 0, 25),
                _buildTableRow(
                    'Recupero:', widget.timerController, 'secondi', 0, 300),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.noteController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Le tue note...',
                hintText: 'Inserisci le tue note qui',
                filled: true,
                fillColor: Colors.grey[900],
                hintStyle: const TextStyle(color: Colors.white54),
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.fromNavBarSchedePred == false)
              _buildStatsButton(context),
            const SizedBox(height: 10),
            if (exerciseDetail.superserieExerciseOrder.isEmpty &&
                widget.fromExercise == false)
              _buildAddSuperSerieButton(context)
            else if (widget.fromExercise == false &&
                exerciseDetail.superserieExerciseOrder.isNotEmpty)
              _buildReorderableList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigazione disabilitata
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 2.0),
          color: Colors.transparent,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.align_horizontal_left, color: Colors.white),
            SizedBox(width: 8.0),
            Text(
              'Le tue statistiche e i tuoi obiettivi!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSuperSerieButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListViewEsercizi(
                fromNavBar: false,
                fromExercise: true,
                fromCreaScheda: widget.fromCreaScheda,
                exerciseDetails: widget.exerciseDetails,
                schedaId: widget.schedaId,
                userId: '',
                userRole: '',
                flagFromSchedaPred: widget.fromNavBarSchedePred,
                requestId: '',
                flagUploadScheda: widget.flagUploadScheda,
                parentsId: widget.exercise.id ?? "",
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white, width: 2.0),
            color: Colors.transparent,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8.0),
              Text(
                'Aggiungi una super-serie!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReorderableList(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        final orderedExercises = provider.superserieExerciseOrder;

        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderedExercises.length,
          itemBuilder: (context, index) {
            final exercise = orderedExercises[index];

            final exerciseMap = provider.superserieDetails[exercise]!;

            final String reps = exerciseMap['num_reps'] ?? '';
            final String sets = exerciseMap['num_sets'] ?? '';
            final String peso = exerciseMap['peso'] ?? '';
            final String timer = exerciseMap['timer'] ?? '';
            final String note = exerciseMap['note'] ?? '';

            return ReorderableDragStartListener(
              key: ValueKey(exercise.id),
              index: index,
              child: CustomGestureDetectorExercise(
                index: index,
                orderedExercise: orderedExercises,
                esercizio: exercise,
                exerciseId: widget.exercise.id ?? '',
                flagCreaScheda: widget.fromCreaScheda,
                repsController: TextEditingController(text: reps),
                setsController: TextEditingController(text: sets),
                timerController: TextEditingController(text: timer),
                pesoController: TextEditingController(text: peso),
                noteController: TextEditingController(text: note),
                numRep: reps,
                numSet: sets,
                timer: timer,
                peso: peso,
                note: note,
                schedaId: widget.schedaId,
                superserieExerciseId: exerciseMap['id'] ?? '',
                exerciseDetails: widget.exerciseDetails,
                flagIsSuperSeriePresent: flagIsSuperSeriePresent,
                flagSuperSerie: flagSuperSerie,
                superserie: widget.superserie,
                flagUploadScheda: false,
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            Provider.of<ExerciseProvider>(context, listen: false)
                .reorderExercises(oldIndex, newIndex);
          },
        );
      },
    );
  }

  TableRow _buildTableRow(String label, TextEditingController controller,
      String suffix, double min, double max) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[600]!),
              ),
              child: TextField(
                controller: controller,
                keyboardType: label == 'Note'
                    ? TextInputType.text
                    : TextInputType
                        .number, // Cambia a TextInputType.text per il campo Note
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixText: suffix,
                  suffixStyle: const TextStyle(color: Colors.white),
                  hintText: label == 'Note' ? 'Inserisci nota' : min.toString(),
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  // Per il campo 'Note', non è necessario limitare la lunghezza
                  if (label != 'Note') {
                    final intValue = int.tryParse(value) ?? min.toInt();
                    if (intValue < min) {
                      controller.text = min.toInt().toString();
                    } else if (intValue > max) {
                      controller.text = max.toInt().toString();
                    } else {
                      controller.text = intValue.toString();
                    }
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.directions_run, 'Parte del corpo:',
              widget.exercise.bodyPart),
          _buildDetailRow(
              Icons.fitness_center, 'Attrezzatura:', widget.exercise.equipment),
          _buildDetailRow(Icons.flag, 'Obiettivo:', widget.exercise.target),
          _buildDetailRow(Icons.group, 'Muscoli secondari:',
              widget.exercise.secondaryMuscles?.join(", ")),
          _buildDetailRow(Icons.description, 'Istruzioni:',
              widget.exercise.instructions?.join(", ")),
          const SizedBox(height: 4.0),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white, // white icon
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0, // enlarged text
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: value ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 18.0, // enlarged text
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
