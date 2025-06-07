// ignore_for_file: use_key_in_widget_constructors, file_names, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/CustomItem/CustomSearchbar.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'package:gymfit/modelli/Exercise.dart';
import 'package:gymfit/modelli/Users.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySelectUserWidget extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final Map<String?, Map<String, String>> exerciseDetails;
  final String userRole;
  final String schedaId;
  final bool schedaPredefinita;
  final String corsoId;
  final bool corso;

  const MySelectUserWidget({
    super.key,
    required this.selectedExercises,
    required this.exerciseDetails,
    required this.userRole,
    required this.schedaPredefinita,
    required this.schedaId,
    required this.corsoId,
    required this.corso,
  });

  @override
  State<MySelectUserWidget> createState() => _MySelectUserWidgetState();
}

class _MySelectUserWidgetState extends State<MySelectUserWidget> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Lista degli Utenti',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String currentUserId = prefs.getString('userId') ?? '';
          String currentUserRole = prefs.getString('userRole') ?? '';
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NavBarAdmin(
              username: '',
              currentUserId: currentUserId,
              userRole: currentUserRole,
              email: '',
            ),
          ));
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: customSearchBar(
          controller: searchController,
          hintText: 'Cerca utenti...',
          onTextChanged: (query) {
            setState(() {
              searchQuery = query.toLowerCase();
            });
          },
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return Stack(children: [
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          }

          final usersList =
              snapshot.data!.map((doc) => Users.fromMap(doc)).toList();

          return RepaintBoundary(
            child: ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final user = usersList[index];
                final userId = user.userId;

                return CustomCard().MyCustomCardAuth(
                    context,
                    user.username,
                    userId,
                    widget.schedaId,
                    '',
                    true,
                    widget.schedaPredefinita,
                    widget.selectedExercises,
                    widget.exerciseDetails,
                    false,
                    widget.userRole,
                    widget.corsoId,
                    widget.corso);
              },
            ),
          );
        },
      ),
    ]);
  }
}
