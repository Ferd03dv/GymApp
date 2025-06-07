// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gymfit/modelli/UsersNotConfirmed.dart';
import '../DAO/UserDAO.dart';

class UsersProvider with ChangeNotifier {
  final UserDAO _userDAO = UserDAO();

  final List<UsersNotConfirmed> _searchedUsers = [];

  List<UsersNotConfirmed> get searchedUsers => _searchedUsers;

  Future<void> uploadBugMongoDB(
      BuildContext context, String bugDescription) async {
    _userDAO.uploadBugMongoDB(context, bugDescription);
  }

  Future<List<Map<String, dynamic>>> searchUsersMongoDB(
      String searchQuery, bool waitingList) async {
    return _userDAO.searchUsersMongoDB(searchQuery, waitingList);
  }

  Future<void> updateUsernameWithUpdate(
      String newUsername, BuildContext context) async {
    _userDAO.updateUsernameWithUpdate(newUsername, context);
  }

  Future<void> deleteUserAccountMongoDB(context) async {
    _userDAO.deleteUserAccountMongoDB(context);
  }

  Future<void> deleteUserAccountFromWaitingListMongoDB(
      String userRole, String email, BuildContext context) async {
    _userDAO.deleteUserAccountFromWaitingListMongoDB(userRole, email, context);
  }

  Future<void> deleteUserAdminMongoDB(
      BuildContext context, String email, String userId) async {
    _userDAO.deleteUserAdminMongoDB(context, email, userId);
  }
}
