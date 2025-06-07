// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import '../Providers/UsersProvider.dart';
import 'package:provider/provider.dart';

import '../CustomItem/BackgroundContainer.dart';

class Segnalazioni extends StatefulWidget {
  const Segnalazioni({super.key});

  @override
  _SegnalazioniState createState() => _SegnalazioniState();
}

class _SegnalazioniState extends State<Segnalazioni> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bugController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Segnalazioni',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return Stack(
      children: [
        const BackgroundContainer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bugController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Segnala il comportamento errato',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore inserisci una descrizione';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        userProvider.uploadBugMongoDB(
                            context, _bugController.text);
                        _bugController.clear();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
