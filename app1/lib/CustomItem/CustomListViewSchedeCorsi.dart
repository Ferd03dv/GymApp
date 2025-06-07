// ignore_for_file: non_constant_identifier_names, file_names
import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import 'package:gymfit/CustomItem/CustomNoTrainigButton.dart';
import 'package:gymfit/Providers/CorsoProvider.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:provider/provider.dart';

class CustomListViewSchede {
  late bool flagCustomSchedePredefinite;

  Widget MyCustomListViewSchede(
      BuildContext context, String userId, bool flag, String userRole) {
    final schedeProvider = Provider.of<SchedeProvider>(context);

    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        //future: schedeProvider.leggiSchedeDaCache(userRole, false),
        future: schedeProvider.schedeStreamAdmin(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Errore: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoTrainingButtonWidget(
              userId: userId,
              userRole: userRole,
              textUp: "Nessun programma di allenamento trovato",
              textDown: "Creane uno ora o chiedi al tuo personal trainer!",
              flag: true,
            );
          }

          List<Map<String, dynamic>> documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> document = documents[index];

              final String nomeScheda = document['nomeScheda'];
              final String schedaId = document['schedaId'];
              final bool schedaPred = document['schedaPred'] as bool;
              final String scandenza = document['scadenza'];

              return CustomCard().MyCustomCardExercise(
                  context,
                  nomeScheda,
                  schedaId,
                  schedaPred,
                  false,
                  userId,
                  userRole,
                  scandenza,
                  false,
                  '');
            },
          );
        },
      ),
    );
  }

  Widget MyCustomListViewSchedePredefinite(
      BuildContext context,
      bool fromNavBarSchedePref,
      String userRole,
      String userId,
      bool flagRichieste,
      String requestId) {
    final schedeProvider = Provider.of<SchedeProvider>(context);

    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: schedeProvider.schedeStreamPredefinite(),
        //future: schedeProvider.leggiSchedeDaCache(userRole, true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: NoTrainingButtonWidget(
              userId: userId,
              userRole: userRole,
              textUp: "Nessuna Scheda Predefinita trovata!",
              textDown: "Creane sul + per crearne una!",
              flag: false,
            ));
          }

          List<Map<String, dynamic>> documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> document = documents[index];

              final String nomeScheda = document['nomeScheda'];
              final String schedaId = document['schedaId'];
              final String scandenza = document['scadenza'];

              return CustomCard().MyCustomCardExercise(
                context,
                nomeScheda,
                schedaId,
                flagCustomSchedePredefinite = true,
                fromNavBarSchedePref = fromNavBarSchedePref,
                userId,
                userRole,
                scandenza,
                flagRichieste,
                requestId,
              );
            },
          );
        },
      ),
    );
  }

  Widget MyCustomListViewCorsi(
      BuildContext context,
      String userRole,
      String userId,
      String username,
      String email,
      String searchQuery,
      bool flagItuoiCorsi) {
    final corsoProvider = Provider.of<CorsoProvider>(context, listen: false);

    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: corsoProvider.searchCorso(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }

          List<Map<String, dynamic>> documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> document = documents[index];
              final String nomeCorso = document['nomeCorso'];
              final String corsoId = document['corsoId'];
              final String descrizione = document['descrizione'];
              final calendario = document['calendario'];
              final utentiIscritti = document['userIds'];
              final utentiInCoda = document['coda'];
              final String maxPersone = document['maxPersone'];
              final String avvisi = document['avvisi'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard().MyCustomCardCorso(
                      context,
                      nomeCorso,
                      corsoId,
                      descrizione,
                      calendario,
                      utentiIscritti,
                      utentiInCoda,
                      maxPersone,
                      avvisi,
                      userRole,
                      userId,
                      username,
                      email),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget MyCustomListViewRichieste(
      BuildContext context, String userId, String userRole) {
    final schedeProvider = Provider.of<SchedeProvider>(context);

    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: schedeProvider.streamSchedeRichieste(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoTrainingButtonWidget(
                userId: userId,
                userRole: userRole,
                textUp: "Non ci sono richieste in attesa per i PT!",
                textDown: userRole == 'user'
                    ? "Clicca sul + o sul bottone per crearne una!"
                    : "Quando avrai delle richieste compilale al piu' presto!",
                flag: false);
          }

          List<Map<String, dynamic>> documents = snapshot.data!;

          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> document = documents[index];

                final String nomeRichiesta = document['tipoAllenamento'];
                final String requestId = document['_id'];
                final String esperienza = document['esperienza'];
                final String eta = document['eta'];
                final String commento = document['commento'];
                final String userIdRequest = document['userId'];

                return CustomCard().MyCustomCardRichiesta(
                    context,
                    nomeRichiesta,
                    userId,
                    userRole,
                    requestId,
                    eta,
                    esperienza,
                    commento,
                    userIdRequest);
              });
        },
      ),
    );
  }
}
