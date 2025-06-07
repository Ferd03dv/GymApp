// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: camel_case_types
class customSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final Function(String)? onTextChanged;

  const customSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200], // Colore di sfondo più chiaro
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onTextChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search,
                color: Colors.grey), // Icona del search bar
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Colors.grey), // Colore del testo del hint
            border:
                InputBorder.none, // Rimuove i bordi per un aspetto più pulito
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            // Applica un bordo circolare all'interno del TextFormField
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
