// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymfit/CustomItem/CustomErrorMessage.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthDAO {
  void createAccountMongo(
    String username,
    String email,
    String password,
    BuildContext context,
    GlobalKey<FormState> formKey,
    bool isAdmin,
  ) async {
    // Verifica se i campi sono vuoti
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Compila Tutti i campi!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Verifica il formato dell'email
    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(
        msg: "Inserisci una email valida!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Verifica la password
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z]).{6,}$'); // Almeno una maiuscola e 6 caratteri
    if (!passwordRegex.hasMatch(password)) {
      Fluttertoast.showToast(
        msg:
            "La password deve essere di almeno 6 caratteri e contenere una lettera maiuscola!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    try {
      var regBody = {
        'user': {
          'username': username,
          'email': email,
          'password': BCrypt.hashpw(password, BCrypt.gensalt()),
          'role': isAdmin ? 'Admin' : 'user',
          'flag': isAdmin ? true : false,
          'createdAt': DateTime.now().toIso8601String(),
          'isAdmin': isAdmin
        }
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.77:3000/registrationWL'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Account creato con successo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Reimposta il form e naviga alla pagina desiderata
        formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/sign_in');
      } else {
        Fluttertoast.showToast(
          msg: "Errore durante la creazione dell'account!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Gestione errori
      debugPrint('Errore durante la creazione dell\'account: $e');
      Fluttertoast.showToast(
        msg: "Errore durante la creazione dell'account!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> signInWithMongoDB(
      String email, String password, BuildContext context) async {
    final schedeProvider = Provider.of<SchedeProvider>(context, listen: false);
    var regBody = {
      'user': {
        'email': email,
        'password': password,
      }
    };

    var response = await http.post(
      Uri.parse('http://192.168.1.77:3000/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String userRole = jsonResponse['userRole'];
      String token = jsonResponse['token'];
      String userName = jsonResponse['userName'];
      String currentUserId = jsonResponse['_id'];
      String flag = jsonResponse['flag'];

      // Salvataggio della email nelle SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setString('userName', userName);
      await prefs.setString('userRole', userRole);
      await prefs.setString('userId', currentUserId);
      await prefs.setString('flag', flag);
      await prefs.setString('token', token);
      await prefs.setBool('isLoggedIn', true);

      if (userRole == 'Admin') {
        schedeProvider.salvaSchedeInCacheAdmin(
            await schedeProvider.schedeStreamPredefinite(),
            await schedeProvider.schedeStreamAdmin(currentUserId));
        schedeProvider.salvaSchedeInCacheUser(
            await schedeProvider.schedeStreamAdmin(currentUserId));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavBarAdmin(
              username: userName,
              currentUserId: currentUserId,
              userRole: userRole,
              email: email,
            ),
          ),
        );
      } else if (userRole == 'user') {
        schedeProvider.salvaSchedeInCacheUser(
            await schedeProvider.schedeStreamAdmin(currentUserId));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavBarUser(
              username: userName,
              currentUserId: currentUserId,
              userRole: userRole,
              email: email,
            ),
          ),
        );
      }
    } else {
      CustomErrorMessage.show(context,
          "L'email o la password non sono corretti. Se ti sei registrato da poco chiedi al desk di accettare il tuo account!");
    }
  }

  Future<void> signOutMongoDB(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.clear();

      Navigator.pushReplacementNamed(context, '/sign_in');
    } catch (e) {
      debugPrint('Errore durante il logout: $e');
      Fluttertoast.showToast(
        msg: "Errore durante il logOut! Effettuare una segnalazione!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  //PROBLEMA CON MONGODB - FARE IL PROPRIO SERVER STMP
  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    if (email.isEmpty) {
      CustomErrorMessage.show(
          context, "L'indirizzo email non può essere vuoto");
      return;
    }

    try {} catch (e) {
      CustomErrorMessage.show(context,
          "Si sono verificati degli errori durante l'invio dell'email di reset della password");
    }
  }

  Future<void> promoteUserToUsersMongoDB(String userRole, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';

    var regBody = {
      'user': {'email': email, 'userRole': userRole}
    };

    var response = await http.post(
        Uri.parse('http://192.168.1.77:3000/promoteUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Account Confermato",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Errore durante la conferma dell'account!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
