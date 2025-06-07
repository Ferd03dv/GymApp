// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/CustomNoTrainigButton.dart';
import 'package:gymfit/modelli/UsersNotConfirmed.dart';
import 'package:provider/provider.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import 'package:gymfit/CustomItem/CustomSearchbar.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'CreateAccount.dart';

class NuoviAccount extends StatefulWidget {
  final String userRole;

  const NuoviAccount({super.key, required this.userRole});

  @override
  State<NuoviAccount> createState() => _NuoviAccountState();
}

class _NuoviAccountState extends State<NuoviAccount> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Nuovi Utenti',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(
                      child: Text(
                    "Conferma iscrizione",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  content: const Text(
                      "Per creare un nuovo account amministratore verrai sloggato. Procedere?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreaAccountWidget(
                                isAdmin: true,
                              ),
                            ),
                          );
                        },
                        child: const Text("OK"),
                      ),
                    )
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Column(
          children: [
            customSearchBar(
              controller: searchController,
              hintText: 'Cerca qui gli utenti...',
              onTextChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    bool flag = false;
    bool flagSchedePredefinite = false;
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    return Stack(
      children: [
        const BackgroundContainer(),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: userProvider.searchUsersMongoDB(searchQuery, true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final usersList = snapshot.data!
                .map((doc) => UsersNotConfirmed.fromMap(doc))
                .toList();
            //..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (usersList.isEmpty) {
              return NoTrainingButtonWidget(
                userId: '',
                userRole: '',
                textUp: "Nessun nuovo utente!",
                textDown: "Ad ogni nuovo iscritto la lista verra' aggiornata!",
                flag: false,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final user = usersList[index];
                return RepaintBoundary(
                  child: CustomCard().MyCustomCardAuth(
                      context,
                      user.username,
                      '',
                      '',
                      user.email,
                      flag,
                      flagSchedePredefinite,
                      [],
                      {},
                      true,
                      widget.userRole,
                      '',
                      false),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
