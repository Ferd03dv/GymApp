// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CorsoDAO {
  Future<void> uploadCorso(
    String nameCorso,
    String dataInizioCorso,
    String? durataCorso,
    List<Map<String, String>> giorniEore,
    String descrizione,
    String massimoNumeroPersone,
    String avviso,
    BuildContext context,
  ) async {
    String corsoId = const Uuid().v4();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    List<Map<String, String>> calendarioCorso = _generateCalendarioCorso(
        dataInizioCorso,
        durataCorso,
        giorniEore,
        int.parse(massimoNumeroPersone));

    List<String> coda = [];
    List<String> userIds = [];

    var regBody = {
      'corso': {
        'corsoId': corsoId,
        'nomeCorso': nameCorso,
        'calendario': calendarioCorso,
        'maxPersone': massimoNumeroPersone,
        'avvisi': avviso,
        'descrizione': descrizione,
        'userIds': userIds,
        'coda': coda,
      }
    };

    final response = await http.post(
        Uri.parse('http://192.168.1.77:3000/createCorso'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Nuovo Corso Aggiunto!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Errore nella crezione del corso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavBarAdmin(
                username: '',
                currentUserId: currentUserId,
                userRole: currentUserRole,
                email: '',
              )));
    }
  }

  Future<void> aggiungiDataOrarioInOrdine(BuildContext context, String corsoId,
      List<Map<String, String>> giorniEOre, List<dynamic> calendario) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      for (var giornoEOra in giorniEOre) {
        calendario.add({
          'data': giornoEOra['giorno'] ?? '',
          'ora': giornoEOra['ora'] ?? '',
        });
      }

      // Ordina l'array basato su "Giorno" e "Ora"
      calendario.sort((a, b) {
        final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
        DateTime dataOraA = format.parse('${a['data']} ${a['ora']}');
        DateTime dataOraB = format.parse('${b['data']} ${b['ora']}');
        return dataOraA.compareTo(dataOraB);
      });

      var regBody = {
        'corso': {'corsoId': corsoId, 'calendario': calendario}
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/updateCalendario'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Nuova data aggiunta!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nel'aggiunta di una nuova data!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      debugPrint("Calendario aggiornato con successo.");
    } catch (e) {
      debugPrint("Errore nell'aggiungere e ordinare data e orario: $e");
    }
  }

  List<Map<String, String>> _generateCalendarioCorso(
      String dataInizioCorso,
      String? durataCorso,
      List<Map<String, String>> giorniEore,
      int maxPersone) {
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(dataInizioCorso);

    int durataInMesi = int.parse(durataCorso?.split(' ')[0] ?? '3');

    DateTime endDate =
        DateTime(startDate.year, startDate.month + durataInMesi, startDate.day);

    Map<String, int> giorniSettimana = {
      'Lunedì': DateTime.monday,
      'Martedì': DateTime.tuesday,
      'Mercoledì': DateTime.wednesday,
      'Giovedì': DateTime.thursday,
      'Venerdì': DateTime.friday,
      'Sabato': DateTime.saturday,
      'Domenica': DateTime.sunday,
    };

    List<Map<String, String>> calendario = [];

    DateTime current = startDate;
    while (current.isBefore(endDate)) {
      for (var giornoOrario in giorniEore) {
        String giorno = giornoOrario['giorno']!;
        String ora = giornoOrario['ora']!;

        int giornoSettimana = giorniSettimana[giorno]!;

        DateTime targetDate = current.add(
          Duration(days: (giornoSettimana - current.weekday + 7) % 7),
        );

        if (targetDate.isBefore(endDate) ||
            targetDate.isAtSameMomentAs(endDate)) {
          calendario.add({
            'data': DateFormat('dd/MM/yyyy').format(targetDate),
            'ora': ora,
          });
        }
      }

      current = current.add(const Duration(days: 7));
    }

    return calendario;
  }

  Future<void> deleteCorso(String corsoId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    var regBody = {
      'corso': {'corsoId': corsoId}
    };

    var response = await http.delete(
        Uri.parse('http://192.168.1.77:3000/deleteCorso'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Corso eliminato!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Errore nell'eliminazione del corso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List<Map<String, dynamic>>> searchCorso(String searchQuery) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final Uri url = Uri.parse('http://192.168.1.77:3000/streamAllCourses');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      };
      var regBody = {'searchQuery': searchQuery};

      final response =
          await http.post(url, headers: headers, body: jsonEncode(regBody));

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

  Future<void> updateCorso(
    BuildContext context,
    String newName,
    String corsoId,
    String descrizione,
    String avvisi,
    String maxPersona,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      var regBody = {
        'corso': {
          'nomeCorso': newName,
          'corsoId': corsoId,
          'descrizione': descrizione,
          'avvisi': avvisi,
          'maxPersone': maxPersona,
        }
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/updateCorso'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Informazioni del corso aggiornate!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nella modifica delle informazioni!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint("Error updating corso: $e");
    }
  }

  Future<void> iscrizioneCorso(
    BuildContext context,
    String corsoId,
    String userId,
    String username,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      var regBody = {
        'corso': {
          'corsoId': corsoId,
        },
        'user': {'userId': userId, 'username': username}
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/addUserToCorso'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Iscritto al corso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'iscrizione al corso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento del corso: $e');
    }
  }

  Future<bool> checkIscrizioneCorso(String corsoId, String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      var regBody = {
        'corso': {
          'corsoId': corsoId,
        },
        'user': {'userId': userId}
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.77:3000/checkUserIscritto'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['res'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(
          'Errore durante il controllo dell\'iscrizione al corso: $e');
    }
  }

  Future<bool> checkCodaCorso(String corsoId, String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      var regBody = {
        'corso': {
          'corsoId': corsoId,
        },
        'user': {'userId': userId}
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.77:3000/checkUserCoda'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['res'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(
          'Errore durante il controllo dell\'iscrizione alla coda: $e');
    }
  }

  Future<void> cancellazioneIscrizioneCorso(
      BuildContext context, String corsoId, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';
    try {
      var regBody = {
        'corso': {
          'corsoId': corsoId,
        },
        'user': {'userId': userId}
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteUserFromCorso'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Iscrizione al corso annullata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'annullamento dell'iscrizione!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NavBarAdmin(
                  username: '',
                  currentUserId: currentUserId,
                  userRole: currentUserRole,
                  email: '',
                )));
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento della scheda: $e');
    }
  }

  Future<void> cancellazioneCodaCorso(
    BuildContext context,
    String corsoId,
    String userId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      String currentUserRole = prefs.getString('userRole') ?? '';
      String currentUserId = prefs.getString('userId') ?? '';

      var regBody = {
        'corso': {
          'corsoId': corsoId,
        },
        'user': {'userId': userId}
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteUserFromCodaCorso'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Iscrizione al corso cancellata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'annullamento dell'iscrizione!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NavBarAdmin(
                  username: '',
                  currentUserId: currentUserId,
                  userRole: currentUserRole,
                  email: '',
                )));
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento della scheda: $e');
    }
  }

  /*void _sendEmail(String email, String message) async {
    try {
      await emailjs.send(
        'service_fdx9zij',
        'template_ky5qf3k',
        {
          'to_email': email,
          'message': message,
        },
        const emailjs.Options(
            publicKey: 'd1Dox-uXNkeE1PKD6',
            privateKey: 'qQDIP6xFIluWijZWlVZVo',
            limitRate: emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      debugPrint('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        debugPrint('ERRORpackage:gymfit. $error');
      }
      debugPrint(error.toString());
    }
  }*/

  Future<void> cancellazioneDataCalendario(
      context, String corsoId, int index, List<dynamic> calendario) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      if (index < 0 || index >= calendario.length) {
        throw Exception('Indice non valido: $index');
      }

      calendario.removeAt(index);

      var regBody = {
        'corso': {'corsoId': corsoId, 'calendario': calendario}
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/updateCalendario'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Data eliminata!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'eliminazione di una data!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      debugPrint('Elemento rimosso correttamente dal calendario.');
    } catch (e) {
      debugPrint('Errore durante la cancellazione: $e');
    }
  }
}
