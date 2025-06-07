// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';

class ChiSiamo extends StatelessWidget {
  const ChiSiamo({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: const Text(
        'Chi siamo',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black, // Colore nero per design coerente
      elevation: 0, // Nessuna ombra
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                    height: 16.0), // Spazio tra il titolo e il contenitore
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.85), // Sfondo semitrasparente
                    borderRadius:
                        BorderRadius.circular(16), // Bordo arrotondato
                  ),
                  child: const Text(
                    'La Ewo Wellness Fitness è una palestra situata nel Beneventano '
                    'in Contrada Piano Cappelle 292. Ci occupiamo di benessere del corpo '
                    'tramite la nostra sala attrezzi, sala cardio ed offrendo corsi per tutte le età ed esigenze.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, // Font più piccolo per un design pulito
                      fontWeight: FontWeight.w500,
                      color: Colors.black87, // Colore leggermente attenuato
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
