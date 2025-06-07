// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SchedeDAO {
  Future<void> salvaSchedeInCacheAdmin(
    List<Map<String, dynamic>> schedePredefinite,
    List<Map<String, dynamic>> schede,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String schedePredefiniteJson = jsonEncode(schedePredefinite);
    final String schedeJson = jsonEncode(schede);
    await prefs.setString('schede_predefinite', schedePredefiniteJson);
    await prefs.setString('schede_admin', schedeJson);
  }

  Future<void> salvaSchedeInCacheUser(
    List<Map<String, dynamic>> schede,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String schedeJson = jsonEncode(schede);
    await prefs.setString('schede_user', schedeJson);
  }

  Future<List<Map<String, dynamic>>> leggiSchedeDaCache(
      String userRole, bool flagSchedePredefinite) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? schedeJson;

    if (userRole == "Admin" && flagSchedePredefinite) {
      schedeJson = prefs.getString('schede_predefinite');
    } else if (userRole == "Admin" && flagSchedePredefinite == false) {
      schedeJson = prefs.getString("schede_admin");
    } else {
      schedeJson = prefs.getString("schede_user");
    }

    if (schedeJson != null) {
      final List<dynamic> data = jsonDecode(schedeJson);
      return List<Map<String, dynamic>>.from(data);
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> schedeStreamAdmin(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';

    try {
      final Uri url = Uri.parse('http://192.168.1.77:3000/streamSchedeAdmin');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      };
      final String body = jsonEncode({
        'user': {'userId': userId}
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Errore durante la richiesta: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> schedeStreamPredefinite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';

    try {
      final Uri url =
          Uri.parse('http://192.168.1.77:3000/streamSchedePredefinite');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      };

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Errore durante la richiesta: $e');
      return [];
    }
  }

  Future<void> addUserToSchedaPredefinita(
      BuildContext context, String schedaId, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';

    try {
      var regBody = {
        'user': {
          'userId': userId,
        },
        'scheda': {'schedaId': schedaId}
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/addUserToSchedaPredefinita'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Utente aggiunto alla scheda!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante l'associazione alla scheda!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento della scheda: $e');
    }
  }

  Future<void> uploadScheda(
    String nameScheda,
    String validitaScheda,
    GlobalKey<FormState> formKey,
    String schedaId,
    String userId,
    String userRole,
    Map<Exercise, Map<String, dynamic>> exerciseDetails,
    bool flag,
    BuildContext context,
  ) async {
    String newSchedaId = const Uuid().v4();

    List<Map<String, dynamic>> selectedExercisesData =
        exerciseDetails.entries.map((entry) {
      final exercise = entry.key;
      final details = entry.value;

      // Estrai i singoli valori dalla lista
      final reps = details['num_reps'];
      final sets = details['num_sets'];
      final peso = details['peso'];
      final timer = details['timer'];
      final note = details['note'];
      final superserie = details['superserie'];

      dynamic parsedSuperserie;

      if (superserie is List<Exercise>) {
        parsedSuperserie = superserie.map((e) => e.id).toList();
      } else if (superserie is Map<Exercise, dynamic>) {
        parsedSuperserie =
            superserie.map((key, value) => MapEntry(key.id, value));
      } else {
        parsedSuperserie = superserie;
      }

      return {
        'id_esercizio': exercise.id,
        'num_reps': reps,
        'num_sets': sets,
        'peso': peso,
        'timer': timer,
        'note': note,
        'superserie': parsedSuperserie,
      };
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';

    var regBody = {
      'scheda': {
        'userId': userId,
        'schedaId': newSchedaId,
        'nomeScheda': nameScheda,
        'scadenza': validitaScheda,
        'schedaPred': false,
        'esercizi': selectedExercisesData,
      }
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.77:3000/createScheda'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      if (currentUserRole == 'Admin') {
        salvaSchedeInCacheAdmin(
            await schedeStreamPredefinite(), await schedeStreamAdmin(userId));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarAdmin(
            username: '',
            currentUserId: currentUserId,
            userRole: currentUserRole,
            email: '',
          ),
        ));
      } else if (currentUserRole == 'user') {
        salvaSchedeInCacheUser(await schedeStreamAdmin(userId));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarUser(
            username: '',
            currentUserId: currentUserId,
            userRole: currentUserRole,
            email: '',
          ),
        ));
      }

      exerciseDetails.clear();

      Fluttertoast.showToast(
        msg: "Nuova scheda aggiunta!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante la creazione della scheda!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> uploadSchedaPredefinita(
      String nameScheda,
      String validitaScheda,
      GlobalKey<FormState> formKey,
      String schedaId,
      Map<Exercise, Map<String, dynamic>> exerciseDetails,
      List<String> userIds,
      BuildContext context) async {
    String newSchedaId = const Uuid().v4();

    List<Map<String, dynamic>> selectedExercisesData =
        exerciseDetails.entries.map((entry) {
      final exercise = entry.key;
      final details = entry.value;

      // Estrai i singoli valori dalla lista
      final reps = details['num_reps'];
      final sets = details['num_sets'];
      final peso = details['peso'];
      final timer = details['timer'];
      final note = details['note'];
      final superserie = details['superserie'];

      dynamic parsedSuperserie;

      if (superserie is List<Exercise>) {
        parsedSuperserie = superserie.map((e) => e.id).toList();
      } else if (superserie is Map<Exercise, dynamic>) {
        parsedSuperserie =
            superserie.map((key, value) => MapEntry(key.id, value));
      } else {
        parsedSuperserie = superserie;
      }

      return {
        'id_esercizio': exercise.id,
        'num_reps': reps,
        'num_sets': sets,
        'peso': peso,
        'timer': timer,
        'note': note,
        'superserie': parsedSuperserie,
      };
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';

    var regBody = {
      'scheda': {
        'userId': userIds,
        'schedaId': newSchedaId,
        'nomeScheda': nameScheda,
        'scadenza': validitaScheda,
        'schedaPred': false,
        'esercizi': selectedExercisesData
      }
    };

    final response = await http.post(
        Uri.parse('http://192.168.1.77:3000/createSchedaPredefinita'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      salvaSchedeInCacheAdmin(await schedeStreamPredefinite(),
          await schedeStreamAdmin(currentUserId));

      Fluttertoast.showToast(
        msg: "Nuova scheda predefinita aggiunta!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarAdmin(
              username: '',
              currentUserId: currentUserId,
              userRole: currentUserRole,
              email: '')));
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante la creazione della scheda",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    selectedExercisesData.clear();
    exerciseDetails.clear();
    selectedExercisesData.clear();
  }

  Future<void> deleteScheda(String userId, String schedaId,
      BuildContext context, String userRole, bool flagSchedaPredefinita) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    try {
      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'flagSchedaPredefinita': flagSchedaPredefinita,
        },
        'user': {'userId': userId, 'userRole': userRole}
      };

      final response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteScheda'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200 && flagSchedaPredefinita == true) {
        Fluttertoast.showToast(
          msg: "Scheda predefinita elimintata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else if (response.statusCode == 200 && flagSchedaPredefinita == false) {
        Fluttertoast.showToast(
          msg: "Scheda eliminata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'eliminazione della scheda!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint('Errore durante l\'upload del bug: $e');
    }
  }

  Future<void> updateNameScheda(BuildContext context, String newName,
      String schedaId, String userRole, bool flagSchedaPredefinita) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';

    try {
      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'newNomeScheda': newName,
          'flagSchedaPredefinita': flagSchedaPredefinita
        }
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/modifySchedaName'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Nome scheda modificato!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante la modifica!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint('Errore durante l\'upload del bug: $e');
    }
  }

  Future<void> addToScheda(
    BuildContext context,
    String schedaId,
    Map<Exercise, Map<String, dynamic>> exerciseDetails,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';

    List<Map<String, dynamic>> selectedExercisesData =
        exerciseDetails.entries.map((entry) {
      final exercise = entry.key;
      final details = entry.value;

      // Estrai i singoli valori dalla lista
      final reps = details['num_reps'];
      final sets = details['num_sets'];
      final peso = details['peso'];
      final timer = details['timer'];
      final note = details['note'];
      final superserie = details['superserie'];

      dynamic parsedSuperserie;

      if (superserie is List<Exercise>) {
        parsedSuperserie = superserie.map((e) => e.id).toList();
      } else if (superserie is Map<Exercise, dynamic>) {
        parsedSuperserie =
            superserie.map((key, value) => MapEntry(key.id, value));
      } else {
        parsedSuperserie = superserie;
      }

      return {
        'id_esercizio': exercise.id,
        'num_reps': reps,
        'num_sets': sets,
        'peso': peso,
        'timer': timer,
        'note': note,
        'superserie': parsedSuperserie,
      };
    }).toList();

    try {
      var regBody = {
        'scheda': {'schedaId': schedaId, 'newDetails': selectedExercisesData},
        'user': {'userRole': currentUserRole},
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/addExerciseToScheda'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Esercizio aggiunto con successo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante l'aggiunta di un esercizio!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint('Errore durante l\'aggiunta dell\'esercizio: $e');
    }
  }

  Future<void> addSuperSerie(
    BuildContext context,
    String schedaId,
    String parentsId,
    Map<Exercise, Map<String, dynamic>> superSerieDetails,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';

    try {
      var regBody = {
        'scheda': {
          'schedaId': schedaId,
          'parentsId': parentsId,
          'newDetails': {
            for (var entry in superSerieDetails.entries)
              entry.key.id: entry.value,
          }
        },
        'user': {'userRole': currentUserRole},
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/addSuperSerie'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Esercizio aggiunto con successo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante l'aggiunta dell'esercizio",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint('Errore durante l\'aggiunta dell\'esercizio: $e');
    }
  }

  Future<List<Exercise>> fetchExercises(String schedaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    var regBody = {
      'scheda': {
        'schedaId': schedaId,
      }
    };

    final response = await http.post(
        Uri.parse('http://192.168.1.77:3000/fetchSchedaExercises'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception(' Impossibile caricare gli esercizi');
    }
  }

  Future<void> uploadNewRequest(BuildContext context, String tipoAllenamento,
      String eta, String esperienza, String commento, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    var regBody = {
      'request': {
        'tipoAllenamento': tipoAllenamento,
        'eta': eta,
        'esperienza': esperienza,
        'commento': commento,
        'userId': userId,
      }
    };

    final response = await http.post(
        Uri.parse('http://192.168.1.77:3000/createRequest'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Richiesta effettuata!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarUser(
              username: '',
              currentUserId: userId,
              userRole: 'user',
              email: '')));
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante l'invio della richiesta",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List<Map<String, dynamic>>> streamSchedeRichieste() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    try {
      var regBody = {
        'user': {'userId': currentUserId, 'userRole': currentUserRole}
      };

      final response = await http.post(
          Uri.parse('http://192.168.1.77:3000/streamRequest'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Errore durante la richiesta: $e');
      return [];
    }
  }

  Future<void> deleteRequest(BuildContext context, String requestId,
      String userId, String userRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    try {
      var regBody = {
        'request': {'requestId': requestId}
      };

      final response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteRequest'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Richiesta eliminata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        if (currentUserRole == 'Admin') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        } else if (currentUserRole == 'user') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NavBarUser(
                    username: '',
                    currentUserId: currentUserId,
                    userRole: currentUserRole,
                    email: '',
                  )));
        }
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante l'eliminazione della richiesta",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint('Errore durante l\'upload del bug: $e');
    }
  }

  Future<void> updateRequest(
      BuildContext context,
      String requestId,
      String tipoAllenamento,
      String eta,
      String esperienza,
      String commento,
      String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    var regBody = {
      'request': {
        'requestId': requestId,
        'tipoAllenamento': tipoAllenamento,
        'eta': eta,
        'esperienza': esperienza,
        'commento': commento,
        'userId': currentUserId,
      }
    };

    final response = await http.put(
        Uri.parse('http://192.168.1.77:3000/updateRequest'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Richiesta aggioranta con successo!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarUser(
              username: '',
              currentUserId: currentUserId,
              userRole: currentUserRole,
              email: '')));
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante l'aggiornamento!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
