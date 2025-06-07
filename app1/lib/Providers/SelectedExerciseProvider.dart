// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../modelli/Exercise.dart';

class SelectedExercisesProvider with ChangeNotifier {
  final List<Exercise> _selectedExercises = [];
  final List<Exercise> _superserieExercises = [];
  final Map<Exercise, Map<String, dynamic>> _exerciseDetails = {};
  final Map<Exercise, Map<String, dynamic>> _superserieDetails = {};

  List<Exercise> get selectedExercises => _selectedExercises;
  List<Exercise> get superserieExercises => _superserieExercises;
  Map<Exercise, Map<String, dynamic>> get exerciseDetails => _exerciseDetails;
  Map<Exercise, Map<String, dynamic>> get superserieDetails =>
      _superserieDetails;

  void addExercise(Exercise exercise) {
    if (exercise.id != null && !_selectedExercises.contains(exercise)) {
      _selectedExercises.add(exercise);
      notifyListeners();
    }
  }

  void addExerciseSuperserie(Exercise exercise) {
    if (exercise.id != null && !_superserieExercises.contains(exercise)) {
      _superserieExercises.add(exercise);
      notifyListeners();
    }
  }

  void clearExercises() {
    _selectedExercises.clear();
    _exerciseDetails.clear();
    notifyListeners();
  }

  void clearExercisesSuperserie() {
    _superserieExercises.clear();
    _exerciseDetails.clear();
    notifyListeners();
  }

  void updateExerciseDetails(
      Exercise exercise, Map<String, dynamic> details, bool fromExercise) {
    if (exercise.id != null) {
      if (fromExercise) {
        // Aggiorna superserieDetails
        final currentDetails = _superserieDetails[exercise] ?? {};

        bool hasChanges = false;
        details.forEach((key, value) {
          if (currentDetails[key] != value) {
            currentDetails[key] = value;
            hasChanges = true;
          }
        });

        if (hasChanges) {
          _superserieDetails[exercise] = currentDetails;
          notifyListeners();
        }
      } else {
        // Aggiorna exerciseDetails (esercizio principale)
        final currentDetails = _exerciseDetails[exercise] ?? {};

        bool hasChanges = false;
        details.forEach((key, value) {
          if (currentDetails[key] != value) {
            currentDetails[key] = value;
            hasChanges = true;
          }
        });

        if (hasChanges) {
          _exerciseDetails[exercise] = currentDetails;
          notifyListeners();
        }
      }
    }
  }

  void clearSuperserieDetails() {
    _superserieDetails.clear();
    notifyListeners();
  }
}
