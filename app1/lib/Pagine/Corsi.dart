// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Admin/CreaCorso.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomSearchbar.dart';

import 'package:gymfit/CustomItem/CustomListViewSchedeCorsi.dart';

class Corsi extends StatefulWidget {
  final String userId;
  final String email;
  final String userRole;
  final String username;

  const Corsi({
    super.key,
    required this.userId,
    required this.email,
    required this.userRole,
    required this.username,
  });

  @override
  State<Corsi> createState() => _CorsiState();
}

class _CorsiState extends State<Corsi> {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  bool showCorsi = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Corsi',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: customSearchBar(
          controller: searchController,
          hintText: 'Cerca qui un corso...',
          onTextChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        ),
      ),
      actions: <Widget>[
        if (widget.userRole == 'Admin') ...{
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CreaCorso(
                    username: widget.username,
                    userRole: widget.userRole,
                    email: widget.email,
                    currentUserId: widget.userId,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        }
      ],
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomListViewSchede().MyCustomListViewCorsi(
                  context,
                  widget.userRole,
                  widget.userId,
                  widget.username,
                  widget.email,
                  searchQuery,
                  showCorsi),
            ],
          ),
        ),
      ],
    );
  }
}
