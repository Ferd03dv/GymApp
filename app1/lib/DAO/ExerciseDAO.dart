// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymfit/Providers/ExerciseProvider.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ExerciseDAO with ChangeNotifier {
  Future<List<Exercise>> fetchExercises(String searchQuery) async {
    final response = await http.post(
        Uri.parse('http://192.168.1.77:3000/api/exercises'),
        body: {'searchQuery': searchQuery});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception(' Impossibile caricare gli esercizi');
    }
  }

  Future<void> deleteExerciseFromDatabase(
      String schedaId, String exerciseId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      String userRole = prefs.getString('userRole') ?? '';

      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'exerciseId': exerciseId,
        },
        'user': {
          'userRole': userRole,
        }
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteExercise'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Esercizio eliminato!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'eliminazione dell'esercizio!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint(
          'Errore durante l\'eliminazione dell\'esercizio dalla superserie: $e');
    }
  }

  Future<void> deleteExerciseFromSuperserie(
    String schedaId,
    String exerciseId,
    String superserieExerciseId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      String userRole = prefs.getString('userRole') ?? '';

      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'exerciseId': exerciseId,
          'superserieId': superserieExerciseId
        },
        'user': {
          'userRole': userRole,
        }
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteSuperSerieExercise'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Super-serie eliminata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'eliminazione della super-serie!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint(
          'Errore durante l\'eliminazione dell\'esercizio dalla superserie: $e');
    }
  }

  Future<void> updateExerciseOrder(BuildContext context, String schedaId,
      List<Exercise> esercizi, String userRole) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      String userRole = prefs.getString('userRole') ?? '';

      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'exercises': esercizi,
        },
        'user': {
          'userRole': userRole,
        }
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.77:3000/updateExerciseOrder'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Esercizi aggiornati!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'aggiornamento degli esercizi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint(
          'Errore durante l\'eliminazione dell\'esercizio dalla superserie: $e');
    }
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
      Map<Exercise, Map<String, dynamic>> superserie,
      bool fromCreaScheda,
      bool fromExercise,
      bool flagSuperSerie,
      bool flagUploadScheda) async {
    try {
      final args = ModalRoute.of(context)?.settings.arguments.toString();

      if (args != null) {
        final selectedProvider =
            Provider.of<ExerciseProvider>(context, listen: false);

        final details = {
          'id_esercizio': exercise.id,
          'num_reps': repsController.text,
          'num_sets': setsController.text,
          'peso': pesoController.text,
          'timer': timerController.text,
          'note': noteController.text,
        };

        if (fromExercise) {
          selectedProvider.updateExerciseDetails(
            exercise,
            details,
            true,
          );
        } else if (fromCreaScheda || flagUploadScheda) {
          selectedProvider.updateExerciseDetails(
            exercise,
            {
              ...details,
              'superserie': selectedProvider.superserieDetails,
            },
            false,
          );
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = prefs.getString('token') ?? '';
          String userRole = prefs.getString('userRole') ?? '';

          var regBody = {
            'scheda': {
              'schedaId': schedaId,
              'exerciseId': exerciseId,
              'details': details,
            },
            'user': {
              'userRole': userRole,
            }
          };

          var response = await http.post(
            Uri.parse('http://192.168.1.77:3000/saveNewData'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(regBody),
          );

          if (response.statusCode == 200) {
            Fluttertoast.showToast(
              msg: "Esercizio aggiornato!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            Fluttertoast.showToast(
              msg: "Errore durante l'aggiornamento dell'esercizio!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }

        selectedProvider.notifyListeners();
      }
    } catch (e) {
      debugPrint('Errore nel salvataggio delle informazioni: $e');
    }
  }
}
