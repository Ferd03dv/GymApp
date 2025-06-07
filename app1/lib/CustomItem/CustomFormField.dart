// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle? labelStyle;
  final bool isNumeric;

  const CustomTextInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.labelStyle,
    this.isNumeric = false, // Impostazione predefinita: input testuale
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: isNumeric
          ? TextInputType.number
          : TextInputType.text, // Cambia il tipo di tastiera
      inputFormatters: isNumeric
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ] // Solo numeri
          : null, // Nessun filtro per testo
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ?? theme.inputDecorationTheme.labelStyle,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
                theme.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                theme.primaryColor,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: const Icon(Icons.clear),
        ),
        floatingLabelStyle:
            labelStyle ?? theme.inputDecorationTheme.floatingLabelStyle,
      ),
    );
  }
}
