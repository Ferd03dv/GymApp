// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymfit/modelli/Exercise.dart';
import '../DAO/ExerciseDAO.dart';

class ExerciseDetailProvider extends ChangeNotifier {
  Duration _duration = const Duration(seconds: 1);
  Timer? _timer;
  bool _isDisposed =
      false; // Flag per controllare se l'oggetto è stato disposto
  bool isSuperserie = false;

  final ExerciseDAO exerciseDAO = ExerciseDAO();

  Duration get duration => _duration;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration = _duration - const Duration(seconds: 1);
        if (!_isDisposed) {
          // Controlla se il provider è ancora valido
          notifyListeners();
        } else {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void setTimer(TextEditingController timerController) {
    final duration = int.tryParse(timerController.text) ?? 0;
    _duration = Duration(seconds: duration);
    notifyListeners();
  }

  Future<void> saveData(
    BuildContext context,
    Exercise exercise,
    String schedaId,
    String exerciseId,
    TextEditingController repsController,
    TextEditingController setsController,
    TextEditingController timerController,
    TextEditingController pesoController,
    TextEditingController noteController,
    Map<Exercise, Map<String, dynamic>> exerciseDetails,
    bool fromCreaScheda,
    bool fromExercise,
    bool flagSuperSerie,
    bool flagUploadScheda,
  ) async {
    await exerciseDAO.saveData(
      context,
      exercise,
      schedaId,
      exerciseId,
      repsController,
      setsController,
      timerController,
      pesoController,
      noteController,
      exerciseDetails,
      fromCreaScheda,
      fromExercise,
      flagSuperSerie,
      flagUploadScheda,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isDisposed = true; // Imposta il flag a true
    super.dispose();
  }

  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }
}
