// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../DAO/CorsoDAO.dart';

class CorsoProvider extends ChangeNotifier {
  final CorsoDAO corso = CorsoDAO();

  Future<void> uploadCorso(
      String nameCorso,
      String data,
      String? durataCorso,
      List<Map<String, String>> giorniEore,
      String descrizione,
      String massimoNumeroPersone,
      String avviso,
      BuildContext context) async {
    corso.uploadCorso(nameCorso, data, durataCorso, giorniEore, descrizione,
        massimoNumeroPersone, avviso, context);
  }

  Future<void> aggiungiDataOrarioInOrdine(BuildContext context, String idCorso,
      List<Map<String, String>> giorniEOre, List<dynamic> calendario) async {
    corso.aggiungiDataOrarioInOrdine(context, idCorso, giorniEOre, calendario);
  }

  Future<void> deleteCorso(
    String corsoId,
    BuildContext context,
  ) async {
    corso.deleteCorso(corsoId, context);
  }

  Future<void> updateCorso(
    BuildContext context,
    String newName,
    String corsoId,
    String descrizione,
    String avvisi,
    String maxPersona,
  ) async {
    corso.updateCorso(
        context, newName, corsoId, descrizione, avvisi, maxPersona);
  }

  Future<void> iscrizioneCorso(
    BuildContext context,
    String corsoId,
    String userId,
    String username,
  ) async {
    corso.iscrizioneCorso(context, corsoId, userId, username);
  }

  Future<bool> checkIscrizioneCorso(String corsoId, String userId) async {
    return corso.checkIscrizioneCorso(corsoId, userId);
  }

  Future<bool> checkCodaCorso(String corsoId, String userId) async {
    return corso.checkCodaCorso(corsoId, userId);
  }

  Future<List<Map<String, dynamic>>> searchCorso(String searchQuery) {
    return corso.searchCorso(searchQuery);
  }

  Future<void> cancellazioneIscrizioneCorso(
    BuildContext context,
    String corsoId,
    String userId,
  ) async {
    corso.cancellazioneIscrizioneCorso(context, corsoId, userId);
  }

  Future<void> cancellazioneCodaCorso(
      BuildContext context, String corsoId, String userId) async {
    corso.cancellazioneCodaCorso(context, corsoId, userId);
  }

  Future<void> cancellazioneDataCalendario(BuildContext context, String corsoId,
      int index, List<dynamic> calendario) async {
    corso.cancellazioneDataCalendario(context, corsoId, index, calendario);
    notifyListeners();
  }
}
