// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Admin/SelectUserWidget.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomButton.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Providers/CorsoProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DescrizioneCorso extends StatefulWidget {
  final String nome;
  final String corsoId;
  final String descrizione;
  final List<dynamic> calendario;
  final List<dynamic> utentiIscritti;
  final List<dynamic> utentiInCoda;
  final String maxPersone;
  final String avvisi;
  final String userRole;
  final String userId;
  final String username;
  final String email;

  const DescrizioneCorso(
      {super.key,
      required this.nome,
      required this.corsoId,
      required this.descrizione,
      required this.calendario,
      required this.utentiIscritti,
      required this.utentiInCoda,
      required this.maxPersone,
      required this.avvisi,
      required this.userRole,
      required this.userId,
      required this.username,
      required this.email});

  @override
  State<DescrizioneCorso> createState() => _DescrizioneCorsoState();
}

class _DescrizioneCorsoState extends State<DescrizioneCorso> {
  late TextEditingController nomeController;
  late TextEditingController maxPersoneController;
  late TextEditingController descrizioneController;
  late TextEditingController avvisiController;
  late CorsoProvider corsoProvider;
  bool isIscritto = false;
  bool isInCoda = false;
  List<Map<String, String>> giorniEOre = [];

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: widget.nome);
    maxPersoneController = TextEditingController(text: widget.maxPersone);
    descrizioneController = TextEditingController(text: widget.descrizione);
    avvisiController = TextEditingController(text: widget.avvisi);

    corsoProvider = Provider.of<CorsoProvider>(context, listen: false);

    corsoProvider
        .checkIscrizioneCorso(widget.corsoId, widget.userId)
        .then((isUserEnrolled) {
      setState(() {
        isIscritto = isUserEnrolled;
      });
    });

    corsoProvider
        .checkCodaCorso(widget.corsoId, widget.userId)
        .then((isUserCoda) {
      setState(() {
        isInCoda = isUserCoda;
      });
    });
  }

  void selezionaDataEOra(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          giorniEOre.clear();
          giorniEOre.add({
            "giorno": DateFormat('dd/MM/yyyy').format(selectedDate),
            "ora": selectedTime.format(context),
          });
        });
      }

      if (context.mounted) {
        corsoProvider
            .aggiungiDataOrarioInOrdine(
                context, widget.corsoId, giorniEOre, widget.calendario)
            .whenComplete(() {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Corso di ${widget.nome}'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(), // Sfondo personalizzato
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCourseInfo(), // Contenuto con le informazioni del corso
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfo() {
    int maxPersone = int.parse(widget.maxPersone);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900], // Sfondo scuro per il contenitore
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _buildEditableField(
                  Icons.title,
                  'Nome:',
                  nomeController,
                  isEditable: widget.userRole == 'Admin',
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableField(Icons.people, 'Massimo numero di iscritti:',
                  maxPersoneController,
                  isEditable: widget.userRole == 'Admin'),
              const SizedBox(height: 10),
              _buildEditableField(
                  Icons.description, 'Descrizione:', descrizioneController,
                  isEditable: widget.userRole == 'Admin'),
              const SizedBox(height: 10),
              _buildEditableField(Icons.warning, 'Avvisi:', avvisiController,
                  isEditable: widget.userRole == 'Admin'),
              const SizedBox(
                height: 10,
              ),
              if (widget.userRole == 'Admin') ...{
                InkWell(
                  onTap: () {
                    selezionaDataEOra(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      color: Colors.transparent,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Aggiungi una data!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => MySelectUserWidget(
                                selectedExercises: const [],
                                exerciseDetails: const {},
                                userRole: '',
                                schedaId: '',
                                schedaPredefinita: false,
                                corsoId: widget.corsoId,
                                corso: true,
                              )),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      color: Colors.transparent,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Aggiungi un Iscritto!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              },
              DefaultTabController(
                  length:
                      widget.userRole == 'Admin' ? 3 : 1, // Numero di schede
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // TabBar per le viste
                    TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        const Tab(
                            icon: Icon(Icons.calendar_today),
                            text: 'Calendario'),
                        if (widget.userRole == 'Admin') ...{
                          const Tab(
                              icon: Icon(Icons.people),
                              text: 'Utenti Iscritti'),
                          const Tab(icon: Icon(Icons.queue), text: 'In Coda'),
                        }
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Contenuto delle schede
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          _buildCalendarioTab(),
                          if (widget.userRole == 'Admin') ...{
                            _buildUtentiTab(true),
                            _buildUtentiTab(false),
                          }
                        ],
                      ),
                    ),
                  ])),
              if (widget.userRole == 'Admin') ...{
                CustomButton(
                  text: 'Salva Modifiche!',
                  onPressed: () async {
                    await corsoProvider
                        .updateCorso(
                      context,
                      nomeController.text,
                      widget.corsoId,
                      descrizioneController.text,
                      avvisiController.text,
                      maxPersoneController.text,
                    )
                        .whenComplete(() {
                      if (mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NavBarAdmin(
                                  username: '',
                                  currentUserId: widget.userId,
                                  userRole: widget.userRole,
                                  email: '',
                                )));
                      }
                    });
                  },
                  colortext: Colors.black,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Elimina Corso!',
                  onPressed: () async {
                    await corsoProvider.deleteCorso(widget.corsoId, context);
                    if (mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NavBarAdmin(
                                username: '',
                                currentUserId: widget.userId,
                                userRole: widget.userRole,
                                email: '',
                              )));
                    }
                  },
                  colortext: Colors.black,
                  backgroundColor: Colors.red,
                )
              } else if (widget.userRole == 'user' && isIscritto) ...{
                CustomButton(
                  text: 'Cancella Iscrizione!',
                  onPressed: () async {
                    await corsoProvider
                        .cancellazioneIscrizioneCorso(
                            context, widget.corsoId, widget.userId)
                        .whenComplete(() {
                      if (mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NavBarUser(
                                  username: '',
                                  currentUserId: widget.userId,
                                  userRole: widget.userRole,
                                  email: '',
                                )));
                      }
                    });
                  },
                  colortext: Colors.white,
                  backgroundColor: Colors.red,
                ),
              } else if (widget.userRole == 'user' &&
                  !isIscritto &&
                  !isInCoda &&
                  maxPersone <= 0) ...{
                CustomButton(
                  text: "Il corso è pieno, mettiti in coda!",
                  onPressed: () async {
                    await corsoProvider
                        .iscrizioneCorso(
                      context,
                      widget.corsoId,
                      widget.userId,
                      widget.username,
                    )
                        .whenComplete(() {
                      if (context.mounted) {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(
                                  child: Text(
                                "Conferma iscrizione",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                              content: Text(
                                  "La tua iscrizione alla coda del corso di ${widget.nome} è stata confermata! "
                                  "Verrai automaticamente iscritto al corso se vi saranno nuovi posti liberi.",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              actions: [
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Chiude il dialog
                                      Navigator.pop(context); // Torna indietro
                                    },
                                    child: const Text("OK"),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                    });
                  },
                  colortext: Colors.black,
                  backgroundColor: Colors.yellow,
                )
              } else if (widget.userRole == 'user' &&
                  !isIscritto &&
                  isInCoda &&
                  maxPersone <= 0) ...{
                CustomButton(
                  text: "Cancellati dalla Coda!",
                  onPressed: () async {
                    corsoProvider
                        .cancellazioneCodaCorso(
                      context,
                      widget.corsoId,
                      widget.userId,
                    )
                        .whenComplete(() {
                      if (mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NavBarUser(
                                  username: '',
                                  currentUserId: widget.userId,
                                  userRole: widget.userRole,
                                  email: '',
                                )));
                      }
                    });
                  },
                  colortext: Colors.black,
                  backgroundColor: Colors.yellow,
                )
              } else if (widget.userRole == 'user' && !isIscritto) ...{
                CustomButton(
                  text: 'Iscriviti al corso!',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Conferma iscrizione'),
                          content: const Text(
                              'Confermando l\'iscrizioni dichiari di aver pagato il corso. Procedere?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Annulla'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                await corsoProvider
                                    .iscrizioneCorso(
                                  context,
                                  widget.corsoId,
                                  widget.userId,
                                  widget.username,
                                )
                                    .whenComplete(() {
                                  if (context.mounted) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => NavBarUser(
                                                  username: '',
                                                  currentUserId: widget.userId,
                                                  userRole: widget.userRole,
                                                  email: '',
                                                )));
                                  }
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  colortext: Colors.white,
                  backgroundColor: Colors.green,
                )
              }
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      IconData icon, String label, TextEditingController controller,
      {required bool isEditable}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: isEditable
                ? TextFormField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$label ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: controller.text,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioTab() {
    if (widget.calendario.isEmpty) {
      return const Center(child: Text('Il calendario è vuoto.'));
    }

    return ListView.builder(
      itemCount: widget.calendario.length,
      itemBuilder: (context, index) {
        final evento = widget.calendario[index];
        return ListTile(
            title: Text(
              'Giorno: ${evento['data']}',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ora: ${evento['ora']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            leading: const Icon(
              Icons.event,
              color: Colors.white,
            ),
            trailing: widget.userRole == 'Admin'
                ? IconButton(
                    onPressed: () {
                      corsoProvider
                          .cancellazioneDataCalendario(
                              context, widget.corsoId, index, widget.calendario)
                          .whenComplete(() {
                        if (context.mounted) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NavBarAdmin(
                                    username: '',
                                    currentUserId: widget.userId,
                                    userRole: widget.userRole,
                                    email: '',
                                  )));
                        }
                      });
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  )
                : SizedBox());
      },
    );
  }

  Widget _buildUtentiTab(bool isIscritto) {
    return ListView.builder(
      itemCount: isIscritto
          ? widget.utentiIscritti.length
          : widget.utentiInCoda.length,
      itemBuilder: (context, index) {
        String userId = isIscritto
            ? widget.utentiIscritti[index]['id']
            : widget.utentiInCoda[index]['id'];

        String username = isIscritto
            ? widget.utentiIscritti[index]['name']
            : widget.utentiInCoda[index]['name'];

        // Combina più chiamate asincrone
        return CustomCard().MyCustomCardUtenteCorso(
            context, username, userId, isIscritto, widget.corsoId);
      },
    );
  }

  @override
  void dispose() {
    // Libero le risorse dei controller
    nomeController.dispose();
    maxPersoneController.dispose();
    descrizioneController.dispose();
    avvisiController.dispose();
    super.dispose();
  }
}
