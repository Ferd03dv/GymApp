// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../DAO/SchedeDAO.dart';
import '../modelli/Exercise.dart';

class SchedeProvider with ChangeNotifier {
  final SchedeDAO schedeDAO = SchedeDAO();

  Future<void> salvaSchedeInCacheAdmin(
      List<Map<String, dynamic>> schedePredefinite,
      List<Map<String, dynamic>> schede) async {
    schedeDAO.salvaSchedeInCacheAdmin(schedePredefinite, schede);
  }

  Future<void> salvaSchedeInCacheUser(List<Map<String, dynamic>> schede) async {
    schedeDAO.salvaSchedeInCacheUser(schede);
  }

  Future<List<Map<String, dynamic>>> leggiSchedeDaCache(
      String userRole, bool flagSchedePredefinite) async {
    return schedeDAO.leggiSchedeDaCache(userRole, flagSchedePredefinite);
  }

  Future<List<Map<String, dynamic>>> schedeStreamAdmin(String userId) {
    return schedeDAO.schedeStreamAdmin(userId);
  }

  Future<List<Map<String, dynamic>>> schedeStreamPredefinite() {
    return schedeDAO.schedeStreamPredefinite();
  }

  Future<void> addUserToSchedaPredefinita(
      BuildContext context, String schedaId, String userId) async {
    return schedeDAO.addUserToSchedaPredefinita(context, schedaId, userId);
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
      BuildContext context) async {
    schedeDAO.uploadScheda(nameScheda, validitaScheda, formKey, schedaId,
        userId, userRole, exerciseDetails, flag, context);

    notifyListeners();
  }

  Future<void> uploadSchedaPredefinita(
      String nameScheda,
      String validitaScheda,
      GlobalKey<FormState> formKey,
      String schedaId,
      Map<Exercise, Map<String, dynamic>> exerciseDetails,
      List<String> userIds,
      BuildContext context) async {
    schedeDAO.uploadSchedaPredefinita(nameScheda, validitaScheda, formKey,
        schedaId, exerciseDetails, userIds, context);
  }

  Future<void> deleteScheda(String userId, String schedaId,
      BuildContext context, String userRole, bool flagSchedaPredefinita) async {
    schedeDAO.deleteScheda(
        userId, schedaId, context, userRole, flagSchedaPredefinita);
  }

  Future<void> updateNameScheda(BuildContext context, String newName,
      String schedaId, String userRole, bool flagSchedaPredefinita) async {
    schedeDAO.updateNameScheda(
        context, newName, schedaId, userRole, flagSchedaPredefinita);
  }

  Future<void> addToScheda(
    BuildContext context,
    String schedaRef,
    Map<Exercise, Map<String, dynamic>> exerciseDetails,
  ) async {
    schedeDAO.addToScheda(
      context,
      schedaRef,
      exerciseDetails,
    );
  }

  void addSuperSerie(
    BuildContext context,
    String schedaRef,
    String parentsId,
    Map<Exercise, Map<String, dynamic>> exerciseDetails,
  ) {
    schedeDAO.addSuperSerie(
      context,
      schedaRef,
      parentsId,
      exerciseDetails,
    );
  }

  Future<List<Exercise>> fetchExercises(String schedaId) async {
    return schedeDAO.fetchExercises(schedaId);
  }

  Future<void> uploadNewRequest(BuildContext context, String tipoAllenamento,
      String eta, String esperienza, String commento, String userId) async {
    return schedeDAO.uploadNewRequest(
        context, tipoAllenamento, eta, esperienza, commento, userId);
  }

  Future<List<Map<String, dynamic>>> streamSchedeRichieste() async {
    return schedeDAO.streamSchedeRichieste();
  }

  Future<void> deleteRequest(BuildContext context, String requestId,
      String userId, String userRole) async {
    schedeDAO.deleteRequest(context, requestId, userId, userRole);
  }

  Future<void> updateRequest(
      BuildContext context,
      String requestId,
      String tipoAllenamento,
      String eta,
      String esperienza,
      String commento,
      String userId) async {
    schedeDAO.updateRequest(
        context, requestId, tipoAllenamento, eta, esperienza, commento, userId);
  }
}
