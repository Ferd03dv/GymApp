// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DAO/AuthDAO.dart';

class AuthProvider with ChangeNotifier {
  final AuthDAO _authDAO = AuthDAO();

  void createAccountMongo(String username, String email, String password,
      BuildContext context, GlobalKey<FormState> formKey, bool isAdmin) async {
    _authDAO.createAccountMongo(
        username, email, password, context, formKey, isAdmin);
  }

  Future<void> signInWithMongoDB(
      String email, String password, BuildContext context) async {
    _authDAO.signInWithMongoDB(email, password, context);
  }

  void signOutMongoDB(
    BuildContext context,
  ) async {
    _authDAO.signOutMongoDB(
      context,
    );
  }

  Future<void> loadSavedCredentials(
      String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null) {
      email = savedEmail;
      rememberMe = true;
    }
    if (savedPassword != null) {
      password = savedPassword;
    }

    notifyListeners();
  }

  void errorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    _authDAO.sendPasswordResetEmail(context, email);
  }

  Future<void> promoteUserToUsersMongoDB(String userRole, String email) async {
    _authDAO.promoteUserToUsersMongoDB(
      userRole,
      email,
    );
  }
}
