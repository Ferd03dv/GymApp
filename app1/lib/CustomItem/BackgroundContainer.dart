// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'dart:ui';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Color.fromARGB(255, 219, 237, 14)],
              stops: [0.5, 0.5],
            ),
          ),
        ),
        // Clip the area to prevent blur from affecting the AppBar
        Padding(
          padding: const EdgeInsets.only(
              top: 15,
              bottom:
                  0), // Aggiungi margine per evitare blur sotto AppBar e sopra Navbar
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.transparent
                    ],
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
