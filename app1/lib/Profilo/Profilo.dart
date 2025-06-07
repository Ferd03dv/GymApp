// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gymfit/Profilo/ModificaProfilo.dart';
import '../CustomItem/BackgroundContainer.dart';
import '../CustomItem/BuildCardButton.dart';
import '../Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class ProfiloWidget extends StatefulWidget {
  final String currentUserId;
  final String userRole;

  const ProfiloWidget(
      {required this.currentUserId, required this.userRole, super.key});

  @override
  State<ProfiloWidget> createState() => _ProfiloWidgetState();
}

class _ProfiloWidgetState extends State<ProfiloWidget> {
  late TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(resizeToAvoidBottomInset: false, body: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Stack(
      children: [
        const BackgroundContainer(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bentornato!',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                BuildCardButton(
                  icon: Icons.person_outline_rounded,
                  text: 'Modifica profilo',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ModificaProfiloWidget(
                          currentUserId: widget.currentUserId,
                          userRole: widget.userRole,
                        ),
                      ),
                    );
                  },
                ),
                BuildCardButton(
                  icon: Icons.info_outlined,
                  text: "Come scaricare l'app",
                  onTap: () {
                    Navigator.of(context).pushNamed('/Download');
                  },
                ),
                BuildCardButton(
                  icon: Icons.info_outlined,
                  text: 'Chi siamo',
                  onTap: () {
                    Navigator.of(context).pushNamed('/ChiSiamo');
                  },
                ),
                BuildCardButton(
                  icon: Icons.bug_report,
                  text: 'Segnala un errore',
                  onTap: () {
                    Navigator.of(context).pushNamed('/Segnalazioni');
                  },
                ),
                BuildCardButton(
                  icon: Icons.mail_outlined,
                  text: 'Contatti',
                  onTap: () {
                    Navigator.of(context).pushNamed('/Contatti');
                  },
                ),
                BuildCardButton(
                  icon: Icons.privacy_tip,
                  text: 'Privacy Policy',
                  onTap: () {
                    Navigator.of(context).pushNamed('/Privacy');
                  },
                ),
                BuildCardButton(
                  icon: Icons.logout,
                  text: 'LogOut',
                  onTap: () {
                    authProvider.signOutMongoDB(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
