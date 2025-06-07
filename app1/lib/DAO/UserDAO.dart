// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDAO {
  Future<void> uploadBugMongoDB(
      BuildContext context, String bugDescription) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    try {
      var regBody = {
        'bugs': {
          'description': bugDescription,
          'createdAt': DateTime.now().toIso8601String(),
        }
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.77:3000/createBugs'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Segnalazione effettuata con successo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nell'invio della segnalazione!",
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

  Future<List<Map<String, dynamic>>> searchUsersMongoDB(
      String searchQuery, bool waitingList) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('token') ?? '';

      var regBody = {'searchQuery': searchQuery, 'waitingList': waitingList};

      final response = await http.post(
          Uri.parse('http://192.168.1.77:3000/search'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Errore durante la ricerca nel catch: $e');
      return [];
    }
  }

  Future<void> updateUsernameWithUpdate(
      String newUsername, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String email = prefs.getString('email') ?? '';
      String token = prefs.getString('token') ?? '';

      var regBody = {
        'user': {'email': email, 'username': newUsername}
      };

      var response = await http.put(
          Uri.parse('http://192.168.1.77:3000/updateUserName'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Dati personali aggiornati con successo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Errore nella modifica dei dati!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint("Error updating username: $e");
    }
  }

  Future<void> deleteUserAccountMongoDB(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String token = prefs.getString('token') ?? '';

      if (email == null) {
        throw Exception('Nessun utente loggato trovato.');
      }

      var regBody = {
        'user': {
          'email': email,
        }
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteUser'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        await prefs.clear();
        Navigator.pushReplacementNamed(context, '/sign_in');
      }
    } catch (e) {
      debugPrint(
          'Si è verificato un errore durante l\'eliminazione dell\'account utente e delle schede associate: $e');
    }
  }

  Future<void> deleteUserAccountFromWaitingListMongoDB(
      String userRole, String email, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    var regBody = {
      'user': {
        'userRole': userRole,
        'email': email,
      }
    };

    var response = await http.delete(
        Uri.parse('http://192.168.1.77:3000/deleteUserFromWL'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Account non confermato!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante l'eliminazione dell'account!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> deleteUserAdminMongoDB(
      BuildContext context, String email, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String currentUserRole = prefs.getString('userRole') ?? '';
    String currentUserId = prefs.getString('userId') ?? '';

    try {
      var regBody = {
        'user': {'email': email, 'userId': userId}
      };

      var response = await http.delete(
          Uri.parse('http://192.168.1.77:3000/deleteUser'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Account non confermato!",
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
                  email: '',
                )));
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante la conferma dell'account!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacementNamed(context, '/nav_bar_admin');
      }
    } catch (error) {
      debugPrint("Si è verificato un errore: $error");
    }
  }
}
