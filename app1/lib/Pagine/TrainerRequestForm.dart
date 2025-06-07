// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gymfit/Admin/SchedePredefinte.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomButton.dart';
import 'package:gymfit/Pagine/CreaScheda.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:provider/provider.dart';

class TrainerRequestForm extends StatefulWidget {
  final String userId;
  final String userRole;
  final String requestId;
  final String tipoAllenamento;
  final String eta;
  final String esperienza;
  final String commento;
  final bool isModified;
  final String userIdRequest;

  const TrainerRequestForm({
    super.key,
    required this.userId,
    required this.userRole,
    required this.requestId,
    required this.tipoAllenamento,
    required this.eta,
    required this.esperienza,
    required this.commento,
    required this.isModified,
    required this.userIdRequest,
  });

  @override
  _TrainerRequestFormState createState() => _TrainerRequestFormState();
}

class _TrainerRequestFormState extends State<TrainerRequestForm> {
  final TextEditingController tipoAllenamentoController =
      TextEditingController();
  final TextEditingController etaController = TextEditingController();
  final TextEditingController commentoController = TextEditingController();
  String? selectedEsperienza;

  @override
  void dispose() {
    tipoAllenamentoController.dispose();
    etaController.dispose();
    commentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedeProvider = Provider.of<SchedeProvider>(context);

    if (widget.isModified) {
      tipoAllenamentoController.text = widget.tipoAllenamento;
      etaController.text = widget.eta;
      commentoController.text = widget.commento;
      selectedEsperienza = widget.esperienza;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Richiesta al Trainer")),
      body: Stack(
        children: [
          const BackgroundContainer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Compila il form per richiedere una scheda!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: tipoAllenamentoController,
                      decoration: const InputDecoration(
                          labelText: "Tipo di allenamento"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Questo campo è obbligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: etaController,
                      decoration: const InputDecoration(labelText: "Età"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Questo campo è obbligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: widget.isModified
                              ? widget.esperienza
                              : "Esperienza"),
                      items: ["Inesperto", "Intermedio", "Avanzato", "Esperto"]
                          .map((level) => DropdownMenuItem(
                              value: level, child: Text(level)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEsperienza = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Questo campo è obbligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: commentoController,
                      decoration: const InputDecoration(
                          hintText: "Commento (opzionale)"),
                      maxLines: 7,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.isModified == true &&
                      widget.userRole == 'user') ...{
                    CustomButton(
                      text: 'Modifica Richiesta!',
                      colortext: Colors.white,
                      onPressed: () {
                        schedeProvider.updateRequest(
                          context,
                          widget.requestId,
                          tipoAllenamentoController.text,
                          etaController.text,
                          selectedEsperienza ?? '',
                          commentoController.text,
                          widget.userId,
                        );
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.black,
                    ),
                  } else if (widget.isModified == false &&
                      widget.userRole == 'user') ...{
                    CustomButton(
                      text: 'Invia Richiesta!',
                      colortext: Colors.white,
                      onPressed: () {
                        schedeProvider.uploadNewRequest(
                          context,
                          tipoAllenamentoController.text,
                          etaController.text,
                          selectedEsperienza ?? '',
                          commentoController.text,
                          widget.userId,
                        );
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.black,
                    ),
                  } else if (widget.userRole == 'Admin') ...{
                    CustomButton(
                      text: 'Crea Nuova Scheda!',
                      colortext: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreaSchedaWidget(
                                    exerciseDetails: {},
                                    schedaPredefinita: false,
                                    userRole: widget.userRole,
                                    userId: widget.userIdRequest,
                                    flagRichieste: true,
                                    userIdRequest: widget.userId,
                                    requestId: widget.requestId,
                                  )),
                        );
                      },
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: 'Assegna Scheda Predefinita!',
                      colortext: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchedePredefinite(
                              userId: widget.userIdRequest,
                              userRole: widget.userRole,
                              flagRichiesta: true,
                              requestId: widget.requestId,
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.black,
                    ),
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
