// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/CustomCard.dart';
import '../Pagine/CreaScheda.dart';
import 'package:provider/provider.dart';
import '../Providers/ExerciseProvider.dart';
import '../Providers/SchedeProvider.dart';
import '../CustomItem/CustomSearchbar.dart';
import '../modelli/Exercise.dart';
import '../CustomItem/BackgroundContainer.dart';

class ListViewEsercizi extends StatefulWidget {
  final bool fromNavBar, fromExercise, fromCreaScheda, flagUploadScheda;
  final Map<Exercise, Map<String, dynamic>> exerciseDetails;
  final String schedaId;
  final String userId;
  final String userRole;
  final bool flagFromSchedaPred;
  final String requestId;
  final String parentsId;

  const ListViewEsercizi({
    super.key,
    required this.fromNavBar,
    required this.fromExercise,
    required this.fromCreaScheda,
    required this.flagUploadScheda,
    required this.exerciseDetails,
    required this.schedaId,
    required this.userId,
    required this.userRole,
    required this.flagFromSchedaPred,
    required this.requestId,
    required this.parentsId,
  });

  @override
  _ListViewEserciziState createState() => _ListViewEserciziState();
}

class _ListViewEserciziState extends State<ListViewEsercizi> {
  List<Exercise> allExercises = [];
  List<Exercise> filteredExercises = [];
  List<Exercise> favoriteExercises = [];
  bool showFavorites = false;
  TextEditingController searchController = TextEditingController();
  late String userRole;
  late String currentUserId;
  String userId = "";
  String currentId = "";
  late ExerciseProvider exerciseProvider;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const BackgroundContainer(),
          Column(
            children: [
              const SizedBox(height: 10),
              PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: customSearchBar(
                    controller: searchController,
                    hintText: 'Cerca esercizi...',
                    onTextChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    }),
              ),
              const SizedBox(height: 10),
              const Text(
                "Clicca sull'esercizio per settare le ripetizioni e il timer",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildExerciseList()),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final schedeProvider = Provider.of<SchedeProvider>(context, listen: false);

    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (widget.fromExercise == true || widget.fromCreaScheda == false) {
            Navigator.pop(
              context,
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CreaSchedaWidget(
                  exerciseDetails:
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .exerciseDetails,
                  schedaPredefinita: widget.flagFromSchedaPred,
                  userRole: widget.userRole,
                  userId: widget.userId,
                  flagRichieste: false,
                  userIdRequest: '',
                  requestId: widget.requestId,
                ),
              ),
            );
          }
        },
      ),
      title: const RepaintBoundary(
        child: Text(
          'Seleziona Esercizi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      centerTitle: true,
      actions: [
        widget.fromNavBar == false && widget.fromCreaScheda == false
            ? IconButton(
                onPressed: widget.parentsId == ''
                    ? () {
                        schedeProvider
                            .addToScheda(
                          context,
                          widget.schedaId,
                          widget.exerciseDetails,
                        )
                            .whenComplete(() {
                          widget.exerciseDetails.clear();
                        });
                      }
                    : () {
                        schedeProvider.addSuperSerie(
                          context,
                          widget.schedaId,
                          widget.parentsId,
                          exerciseProvider.superserieDetails,
                        );
                      },
                icon: const Icon(Icons.check),
              )
            : SizedBox()
      ],
    );
  }

  Widget _buildExerciseList() {
    return FutureBuilder<List<Exercise>>(
      future: exerciseProvider.fetchExercises(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nessun esercizio trovato'));
        }

        final exercises = snapshot.data!;

        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final ex = exercises[index];
            return CustomCard().MyCustomCardEsercizio(
                context,
                ex,
                widget.fromExercise,
                widget.flagFromSchedaPred,
                widget.fromCreaScheda,
                widget.flagUploadScheda);
          },
        );
      },
    );
  }
}
