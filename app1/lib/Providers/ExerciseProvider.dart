// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../DAO/ExerciseDAO.dart';
import '../modelli/Exercise.dart';

class ExerciseProvider with ChangeNotifier {
  final ExerciseDAO exerciseDAO = ExerciseDAO();

  Map<Exercise, Map<String, dynamic>> _exerciseDetails = {};
  Map<Exercise, Map<String, dynamic>> _superserieExerciseDetails = {};
  List<Exercise> _exerciseOrder = [];
  List<Exercise> _superserieExerciseOrder = [];

  Map<Exercise, Map<String, dynamic>> get exerciseDetails => _exerciseDetails;
  Map<Exercise, Map<String, dynamic>> get superserieDetails =>
      _superserieExerciseDetails;
  List<Exercise> get exerciseOrder => _exerciseOrder;
  List<Exercise> get superserieExerciseOrder => _superserieExerciseOrder;

  void setExerciseDetails(Map<Exercise, Map<String, dynamic>> details) {
    _exerciseDetails = details;
    _exerciseOrder = details.keys.toList();
    notifyListeners();
  }

  void setSuperSerieExerciseDetails(
      Map<Exercise, Map<String, dynamic>> details) {
    _superserieExerciseDetails = details;
    _superserieExerciseOrder = details.keys.toList();
    notifyListeners();
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final item = _exerciseOrder.removeAt(oldIndex);
    _exerciseOrder.insert(newIndex, item);

    final newDetails = <Exercise, Map<String, dynamic>>{};
    for (final exercise in _exerciseOrder) {
      if (_exerciseDetails.containsKey(exercise)) {
        newDetails[exercise] = _exerciseDetails[exercise]!;
      }
    }

    _exerciseDetails
      ..clear()
      ..addAll(newDetails);

    notifyListeners();
  }

  Future<void> deleteExerciseFromDatabase(
      String schedaId, String exerciseId) async {
    await exerciseDAO.deleteExerciseFromDatabase(schedaId, exerciseId);
    notifyListeners();
  }

  void deleteExerciseFromList(
    int index,
    bool fromExercise,
  ) {
    final details = fromExercise ? superserieDetails : exerciseDetails;
    final order = fromExercise ? superserieExerciseOrder : exerciseOrder;

    if (index < 0 || index >= order.length) return;

    final exercise = order[index];
    final detail = details[exercise] ?? {};

    // Reset dei dettagli
    detail['reps'] = '';
    detail['sets'] = '';
    detail['timer'] = '';
    detail['note'] = '';
    detail['peso'] = '';
    detail['superserie'] = {};

    details.remove(exercise);
    order.removeAt(index);

    notifyListeners();
  }

  Future<void> updateExerciseOrder(BuildContext context, schedaId,
      List<Exercise> esercizi, String userRole) async {
    await exerciseDAO.updateExerciseOrder(
        context, schedaId, esercizi, userRole);
    notifyListeners();
  }

  Future<List<Exercise>> fetchExercises(String searchQuery) async {
    return exerciseDAO.fetchExercises(searchQuery);
  }

  void addExercise(Exercise exercise) {
    if (exercise.id != null && !_exerciseOrder.contains(exercise)) {
      _exerciseOrder.add(exercise);
      notifyListeners();
    }
  }

  void addExerciseSuperserie(Exercise exercise) {
    if (exercise.id != null && !_superserieExerciseOrder.contains(exercise)) {
      _superserieExerciseOrder.add(exercise);
      notifyListeners();
    }
  }

  void clearExercises() {
    _exerciseOrder.clear();
    _exerciseDetails.clear();
    notifyListeners();
  }

  void clearExercisesSuperserie() {
    _superserieExerciseOrder.clear();
    _exerciseDetails.clear();
    notifyListeners();
  }

  void updateExerciseDetails(
      Exercise exercise, Map<String, dynamic> details, bool fromExercise) {
    if (exercise.id != null) {
      if (fromExercise) {
        final currentDetails = _superserieExerciseDetails[exercise] ?? {};

        bool hasChanges = false;
        details.forEach((key, value) {
          if (currentDetails[key] != value) {
            currentDetails[key] = value;
            hasChanges = true;
          }
        });

        if (!_superserieExerciseOrder.contains(exercise)) {
          _superserieExerciseOrder.add(exercise);
          hasChanges = true;
        }

        if (hasChanges) {
          _superserieExerciseDetails[exercise] = currentDetails;
          notifyListeners();
        }
      } else {
        final currentDetails = _exerciseDetails[exercise] ?? {};

        bool hasChanges = false;
        details.forEach((key, value) {
          if (currentDetails[key] != value) {
            currentDetails[key] = value;
            hasChanges = true;
          }
        });

        if (!_exerciseOrder.contains(exercise)) {
          _exerciseOrder.add(exercise);
          hasChanges = true;
        }

        if (hasChanges) {
          _exerciseDetails[exercise] = currentDetails;
          notifyListeners();
        }
      }
    }
  }

  void clearSuperserieDetails() {
    _superserieExerciseDetails.clear();
    notifyListeners();
  }

  Future<void> deleteExerciseFromSuperserie(
    String schedaId,
    String exerciseId,
    String superserieExerciseId,
  ) async {
    exerciseDAO.deleteExerciseFromSuperserie(
        schedaId, exerciseId, superserieExerciseId);

    notifyListeners();
  }
}
