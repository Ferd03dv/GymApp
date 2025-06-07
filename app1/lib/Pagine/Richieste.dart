// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomListViewSchedeCorsi.dart';
import 'package:gymfit/CustomItem/CustomNavBar.dart';
import 'package:gymfit/Pagine/TrainerRequestForm.dart';

class Richieste extends StatefulWidget {
  final String userId;
  final String userRole;

  const Richieste({super.key, required this.userId, required this.userRole});

  @override
  State<Richieste> createState() => _RichiesteState();
}

class _RichiesteState extends State<Richieste> {
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
      title: widget.userRole == 'user'
          ? Text(
              'Le tue richieste!',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          : Text(
              'Richieste per nuove schede!',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
      automaticallyImplyLeading: false,
      leading: widget.userRole == 'Admin'
          ? IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavBarAdmin(
                            username: '',
                            currentUserId: widget.userId,
                            userRole: widget.userRole,
                            email: '')));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )
          : SizedBox(),
      actions: [
        widget.userRole == 'user'
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrainerRequestForm(
                              userId: widget.userId,
                              userRole: widget.userRole,
                              tipoAllenamento: '',
                              eta: '',
                              esperienza: '',
                              commento: '',
                              isModified: false,
                              requestId: '',
                              userIdRequest: '',
                            )),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : SizedBox(),
      ],
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        Column(
          children: [
            CustomListViewSchede().MyCustomListViewRichieste(
                context, widget.userId, widget.userRole)
          ],
        )
      ],
    );
  }
}
