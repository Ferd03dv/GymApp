// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomButton.dart';
import 'package:gymfit/CustomItem/CustomFormField.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Providers/CorsoProvider.dart';
import 'package:provider/provider.dart';

class CreaCorso extends StatefulWidget {
  final String username;
  final String currentUserId;
  final String userRole;
  final String email;

  const CreaCorso({
    super.key,
    required this.username,
    required this.currentUserId,
    required this.userRole,
    required this.email,
  });

  @override
  State<CreaCorso> createState() => _CreaCorsoState();
}

class _CreaCorsoState extends State<CreaCorso> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descrizioneController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _numPersoneController = TextEditingController();
  final TextEditingController _avvisoController = TextEditingController();
  String? durataCorso;

  @override
  void dispose() {
    _nomeController.dispose();
    _descrizioneController.dispose();
    _dataController.dispose();
    _numPersoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dataController.text = selectedDate
            .toLocal()
            .toString()
            .split(' ')[0]; // Salva la data come stringa
      });
    }
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: const Text('Crea Corso'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NavBarAdmin(
                username: widget.username,
                currentUserId: widget.currentUserId,
                userRole: widget.userRole,
                email: widget.email,
              ),
            ),
          );
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
    CorsoProvider corsoProvider =
        Provider.of<CorsoProvider>(context, listen: false);
    List<Map<String, String>> giorniEOre = [];

    return Stack(
      children: [
        const BackgroundContainer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: CustomTextInput(
                    controller: _nomeController,
                    labelText: "Nome del corso...",
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: CustomTextInput(
                    controller: _descrizioneController,
                    labelText: "Descrizione del corso...",
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _dataController,
                      readOnly: true, // Impedisce l'inserimento manuale
                      onTap: () {
                        _selectDate(context); // Mostra il selettore di date
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        labelText: 'Data Inizio Corso...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Durata del corso",
                      border: InputBorder.none,
                    ),
                    value: durataCorso,
                    items: List.generate(
                      10,
                      (index) {
                        final mesi = 3 + index;
                        return DropdownMenuItem<String>(
                          value: "$mesi mesi",
                          child: Text("$mesi mesi"),
                        );
                      },
                    ),
                    onChanged: (value) {
                      setState(() {
                        durataCorso = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () async {
                    await _showGiorniEOreDialog(context, giorniEOre);
                  },
                  text: "Giorni - Ore - Durata",
                  backgroundColor: Colors.white,
                  colortext: Colors.black,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: CustomTextInput(
                    controller: _numPersoneController,
                    labelText: 'Massimo numero di iscritti...',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: CustomTextInput(
                    controller: _avvisoController,
                    labelText: 'Aggiungi un avviso...',
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Crea il nuovo corso!',
                  onPressed: () {
                    if (_nomeController.text.isEmpty ||
                        _dataController.text.isEmpty ||
                        durataCorso!.isEmpty ||
                        giorniEOre.isEmpty ||
                        _descrizioneController.text.isEmpty ||
                        _numPersoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Compila tutti i campi tranne avviso e aggiungi almeno un giorno e ora!',
                          ),
                          duration: Duration(seconds: 4),
                          backgroundColor: Colors.red,
                        ),
                      );

                      return; // Blocca la creazione del corso
                    } else {
                      if (_formKey.currentState!.validate()) {
                        corsoProvider
                            .uploadCorso(
                                _nomeController.text,
                                _dataController.text,
                                durataCorso,
                                giorniEOre,
                                _descrizioneController.text,
                                _numPersoneController.text,
                                _avvisoController.text,
                                context)
                            .whenComplete(() {
                          _formKey.currentState?.reset();
                        });
                      }
                    }
                  },
                  colortext: Colors.black,
                  backgroundColor: Colors.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showGiorniEOreDialog(
      BuildContext context, List<Map<String, String>> giorniEOre) async {
    final Map<String, TimeOfDay?> giorniSelezionati = {
      "Lunedì": null,
      "Martedì": null,
      "Mercoledì": null,
      "Giovedì": null,
      "Venerdì": null,
      "Sabato": null,
      "Domenica": null,
    };

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Seleziona Giorni e Ore!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: giorniSelezionati.keys.map((giorno) {
                        return CheckboxListTile(
                          title: Text(giorno),
                          value: giorniSelezionati[giorno] != null,
                          onChanged: (val) async {
                            if (val == true) {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  giorniSelezionati[giorno] = pickedTime;
                                });
                              }
                            } else {
                              setState(() {
                                giorniSelezionati[giorno] = null;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Salva le coppie giorni e ore
                      giorniEOre.clear();
                      giorniSelezionati.forEach((giorno, ora) {
                        if (ora != null) {
                          giorniEOre.add({
                            "giorno": giorno,
                            "ora": ora.format(context),
                          });
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Conferma",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
