// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gymfit/Admin/SelectUserWidget.dart';
import 'package:gymfit/Admin/UserPageAdmin.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Pagine/DescrizioneCorso.dart';
import 'package:gymfit/Pagine/DettagliEsercizi.dart';
import 'package:gymfit/Pagine/DettagliScheda.dart';
import 'package:gymfit/Pagine/TrainerRequestForm.dart';
import 'package:gymfit/Providers/AuthProvider.dart';
import 'package:gymfit/Providers/CorsoProvider.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:gymfit/Providers/SelectedExerciseProvider.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomCard {
  Widget MyCustomCardAuth(
    BuildContext context,
    String username,
    String userId,
    String schedaId,
    String email,
    bool flag,
    bool flagSchedePredefinite,
    List<Exercise> selectedExercises,
    Map<String?, Map<String, dynamic>> exerciseDetails,
    bool waitinglist,
    String userRole,
    String corsoId,
    bool corso,
  ) {
    final schedeProvider = Provider.of<SchedeProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final corsoProvider = Provider.of<CorsoProvider>(context, listen: false);

    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          String currentUserRole = prefs.getString('userRole') ?? '';
          String currentUserId = prefs.getString('userId') ?? '';

          if (flagSchedePredefinite == true && corso == false) {
            await schedeProvider
                .addUserToSchedaPredefinita(context, schedaId, userId)
                .whenComplete(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => NavBarAdmin(
                          username: '',
                          currentUserId: currentUserId,
                          userRole: currentUserRole,
                          email: '',
                        )),
              );
            });
          } else if (corso == false) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserPageAdmin(
                  email: email,
                  userId: userId,
                  userRole: userRole,
                  username: username,
                ),
              ),
            );
          } else {
            corsoProvider
                .iscrizioneCorso(context, corsoId, userId, username)
                .whenComplete(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => NavBarAdmin(
                          username: username,
                          currentUserId: currentUserId,
                          userRole: currentUserRole,
                          email: email,
                        )),
              );
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.person, size: 25, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (waitinglist) ...{
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        userProvider.deleteUserAccountFromWaitingListMongoDB(
                            userRole, email, context);
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        authProvider.promoteUserToUsersMongoDB(userRole, email);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NavBarAdmin(
                                  username: '',
                                  currentUserId: userId,
                                  userRole: userRole,
                                  email: '',
                                )));
                      },
                      icon: const Icon(Icons.check, color: Colors.green),
                    ),
                  ],
                ),
              } else ...{
                const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              }
            ],
          ),
        ),
      ),
    );
  }

  Widget MyCustomCardUtenteCorso(BuildContext context, String username,
      String userId, bool isIscritto, String corsoId) {
    final corsoProvider = Provider.of<CorsoProvider>(context, listen: false);

    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.person, size: 25, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isIscritto == false) ...{
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        corsoProvider.cancellazioneCodaCorso(
                            context, corsoId, userId);
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                    ),
                  ],
                ),
              } else ...{
                IconButton(
                  onPressed: () {
                    corsoProvider.cancellazioneIscrizioneCorso(
                        context, corsoId, userId);
                  },
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }

  Widget MyCustomCardExercise(
    BuildContext context,
    String nomeScheda,
    String schedaId,
    bool flagSchedePredefinite,
    bool fromNavBarSchedePref,
    String userId,
    String userRole,
    String scadenza,
    bool flagRichiesta,
    String requestId,
  ) {
    TextEditingController repsController = TextEditingController(text: '8');
    TextEditingController setsController = TextEditingController(text: '3');
    TextEditingController timerController = TextEditingController(text: '60');
    TextEditingController noteController = TextEditingController(text: 'note');
    final schedeProvider = Provider.of<SchedeProvider>(context, listen: false);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DettagliScheda(
              schedaId: schedaId,
              flagSchedePredefinite: flagSchedePredefinite,
              repsController: repsController,
              setsController: setsController,
              timerController: timerController,
              noteController: noteController,
              fromNavBar: fromNavBarSchedePref,
              userId: userId,
              scadenza: scadenza,
              nomeScheda: nomeScheda,
              userRole: userRole,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  nomeScheda,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (flagSchedePredefinite == true &&
                  userRole == 'Admin' &&
                  flagRichiesta == false) ...{
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MySelectUserWidget(
                                selectedExercises: const [],
                                exerciseDetails: const {},
                                userRole: userRole,
                                schedaId: schedaId,
                                schedaPredefinita: flagSchedePredefinite,
                                corsoId: '',
                                corso: false)),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    )),
              } else if (flagSchedePredefinite == true &&
                  userRole == 'Admin' &&
                  flagRichiesta == true) ...{
                IconButton(
                    onPressed: () {
                      schedeProvider
                          .addUserToSchedaPredefinita(context, schedaId, userId)
                          .whenComplete(() {
                        schedeProvider.deleteRequest(
                            context, requestId, userId, userRole);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => NavBarAdmin(
                                    username: '',
                                    currentUserId: userId,
                                    userRole: userRole,
                                    email: '',
                                  )),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    )),
              },
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyCustomCardCorso(
    BuildContext context,
    String nomeCorso,
    String corsoId,
    String descrizione,
    List<dynamic> calendario,
    List<dynamic> utentiIscritti,
    List<dynamic> utentiInCoda,
    String maxPersone,
    String avvisi,
    String userRole,
    String userId,
    String username,
    String email,
  ) {
    bool isIscritto = utentiIscritti.any((utente) => utente['id'] == userId);
    bool isInCoda = utentiInCoda.any((utente) => utente['id'] == userId);

    String stato;
    Color statoColore;

    if (isIscritto) {
      stato = 'Iscritto';
      statoColore = Colors.green;
    } else if (isInCoda) {
      stato = 'In Coda';
      statoColore = Colors.amber;
    } else {
      stato = 'Non iscritto';
      statoColore = Colors.red;
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DescrizioneCorso(
              nome: nomeCorso,
              corsoId: corsoId,
              descrizione: descrizione,
              calendario: calendario,
              utentiIscritti: utentiIscritti,
              utentiInCoda: utentiInCoda,
              maxPersone: maxPersone,
              avvisi: avvisi,
              userRole: userRole,
              userId: userId,
              username: username,
              email: email,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Icon(
                  Icons.people,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nomeCorso,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          stato,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: statoColore,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Posti disponibili: $maxPersone',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Avvisi: $avvisi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyCustomCardRichiesta(
      BuildContext context,
      String nomeRichiesta,
      String userId,
      String userRole,
      String requestId,
      String eta,
      String esperienza,
      String commento,
      String userIdRequest) {
    final schedaProvider = Provider.of<SchedeProvider>(context, listen: false);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Icon(
                  Icons.assignment,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nomeRichiesta,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                schedaProvider.deleteRequest(
                                    context, requestId, userId, userRole);
                              },
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TrainerRequestForm(
                                            userId: userId,
                                            userRole: userRole,
                                            tipoAllenamento: nomeRichiesta,
                                            eta: eta,
                                            esperienza: esperienza,
                                            commento: commento,
                                            isModified: true,
                                            requestId: requestId,
                                            userIdRequest: userIdRequest,
                                          )),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_square,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyCustomCardEsercizio(
    BuildContext context,
    Exercise exercise,
    bool fromExercise,
    bool fromSchedaPred,
    bool fromCreaScheda,
    bool flagUploadScheda,
  ) {
    TextEditingController repsController = TextEditingController();
    TextEditingController setsController = TextEditingController();
    TextEditingController timerController = TextEditingController();
    TextEditingController ultimoPesoController = TextEditingController();
    TextEditingController noteController = TextEditingController();

    final selectedProvider =
        Provider.of<SelectedExercisesProvider>(context, listen: false);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DettagliEsercizi(
                    exercise: exercise,
                    repsController: repsController,
                    setsController: setsController,
                    timerController: timerController,
                    pesoController: ultimoPesoController,
                    noteController: noteController,
                    numRep: '8',
                    numSet: '3',
                    timer: '60',
                    peso: '0',
                    note: 'note',
                    schedaPredDB: 'false',
                    fromNavBarSchedePred: fromSchedaPred,
                    schedaId: '',
                    flagPreferiti: false,
                    fromCreaScheda: fromCreaScheda,
                    fromFirstPage: false,
                    exerciseDetails: selectedProvider.exerciseDetails,
                    fromExercise: fromExercise,
                    superserie: {},
                    flagUploadScheda: flagUploadScheda,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Image.network(
                  'http://192.168.1.77:3000/gif/${exercise.gifFilename}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: exercise.name ?? '',
                      child: Text(
                        exercise.name ?? '',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Tooltip(
                      message: exercise.target ?? '',
                      child: Text(
                        exercise.target ?? '',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
