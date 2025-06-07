// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import '../CustomItem/BackgroundContainer.dart';

class Download extends StatelessWidget {
  const Download({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: null, // Assicura che il leading non venga mostrato
      automaticallyImplyLeading:
          true, // Disabilita l'indicazione automatica del pulsante di ritorno
      title: const Text(
        'Come Installare la Web App',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white, // Imposta il colore del testo a bianco
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black, // Colore di sfondo dell'AppBar
      elevation: 0, // Rimuove l'ombra
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        const BackgroundContainer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                    0.85), // Aggiunge trasparenza per effetto minimal
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ridimensiona in base al contenuto
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    'Su iPhone',
                    '1. Apri Safari e visita il nostro sito web.\n'
                        '2. Tocca il pulsante di condivisione nella parte inferiore.\n'
                        '3. Seleziona "Aggiungi a Home".\n'
                        '4. Dai un nome alla tua app e tocca "Aggiungi".',
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    context,
                    'Su Android',
                    '1. Apri Chrome e visita il nostro sito web.\n'
                        '2. Tocca il menu del browser (tre puntini in alto).\n'
                        '3. Seleziona "Aggiungi alla schermata iniziale".\n'
                        '4. Dai un nome alla tua app e tocca "Aggiungi".',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, String title, String instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          instructions,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
