// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import 'package:gymfit/CustomItem/CustomSearchbar.dart';
import 'package:gymfit/Pagine/Richieste.dart';
import 'package:gymfit/Providers/SchedeProvider.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'package:gymfit/modelli/Users.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class ListViewUtenti extends StatefulWidget {
  final String userId;
  final String userRole;

  const ListViewUtenti(
      {super.key, required this.userId, required this.userRole});

  @override
  State<ListViewUtenti> createState() => _ListViewUtentiState();
}

class _ListViewUtentiState extends State<ListViewUtenti> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  late Future<List<Map<String, dynamic>>> streamRichieste;
  int numeroRichieste = 0;

  @override
  void initState() {
    super.initState();

    final schedeProvider = Provider.of<SchedeProvider>(context, listen: false);

    streamRichieste = schedeProvider.streamSchedeRichieste();

    streamRichieste.then((lista) {
      setState(() {
        numeroRichieste = lista.length;
      });
    });
  }

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
        'I tuoi abbonati',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: customSearchBar(
          controller: searchController,
          hintText: 'Cerca qui gli utenti...',
          onTextChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    Richieste(userId: widget.userId, userRole: widget.userRole),
              ),
            );
          },
          icon: badges.Badge(
            badgeContent: Text(
              numeroRichieste.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.red,
            ),
            child: const Icon(
              Icons.request_page,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
          future: userProvider.searchUsersMongoDB(searchQuery, false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Errore durante il caricamento degli utenti.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }

            final usersList =
                snapshot.data!.map((doc) => Users.fromMap(doc)).toList();

            if (usersList.isEmpty) {
              return const Center(
                child: Text(
                  'Nessun utente trovato.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }

            // Raggruppa per ruolo
            Map<String, List<Users>> usersByRole = {};
            for (var user in usersList) {
              String ruolo = user.role;

              usersByRole.putIfAbsent(ruolo, () => []);
              usersByRole[ruolo]!.add(user);
            }

            // Ordina per ruoli principali
            List<String> orderedRoles = ['Admin', 'user'];
            orderedRoles.addAll(usersByRole.keys
                .where((role) => role != 'Admin' && role != 'user'));

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: orderedRoles
                  .where((role) => usersByRole.containsKey(role))
                  .map((role) {
                List<Users> usersInRole = usersByRole[role]!;

                if (role == 'user') {
                  // Ordina per nome solo gli utenti con ruolo 'user'
                  usersInRole.sort((a, b) => a.username
                      .toLowerCase()
                      .compareTo(b.username.toLowerCase()));

                  // Raggruppa per la prima lettera
                  Map<String, List<Users>> groupedUsers = {};
                  for (var user in usersInRole) {
                    String firstLetter =
                        user.username.substring(0, 1).toUpperCase();
                    groupedUsers.putIfAbsent(firstLetter, () => []);
                    groupedUsers[firstLetter]!.add(user);
                  }

                  // Mostra intestazione per lettera
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Abbonati: ${usersInRole.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ...groupedUsers.keys.map((letter) {
                        List<Users> usersInGroup = groupedUsers[letter]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Center(
                                child: Text(
                                  '- $letter -',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: usersInGroup.map((user) {
                                return RepaintBoundary(
                                  child: CustomCard().MyCustomCardAuth(
                                      context,
                                      user.username,
                                      user.userId,
                                      '',
                                      user.email,
                                      flag,
                                      flagSchedePredefinite,
                                      [],
                                      {},
                                      false,
                                      user.role,
                                      '',
                                      false),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                } else {
                  // Per altri ruoli, visualizza direttamente
                  String displayRole = role == 'Admin' ? 'Personale' : role;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '$displayRole: ${usersInRole.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        children: usersInRole.map((user) {
                          return RepaintBoundary(
                            child: CustomCard().MyCustomCardAuth(
                                context,
                                user.username,
                                user.userId,
                                '',
                                user.email,
                                flag,
                                flagSchedePredefinite,
                                [],
                                {},
                                false,
                                user.role,
                                '',
                                false),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
