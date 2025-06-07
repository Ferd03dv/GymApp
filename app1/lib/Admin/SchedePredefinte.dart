// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomListViewSchedeCorsi.dart';
import 'package:gymfit/Pagine/CreaScheda.dart';

class SchedePredefinite extends StatefulWidget {
  final String userId;
  final String userRole;
  final bool flagRichiesta;
  final String requestId;

  const SchedePredefinite({
    super.key,
    required this.userId,
    required this.userRole,
    required this.flagRichiesta,
    required this.requestId,
  });

  @override
  State<SchedePredefinite> createState() => _SchedePredefiniteState();
}

class _SchedePredefiniteState extends State<SchedePredefinite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: widget.flagRichiesta ? true : false,
      title: const RepaintBoundary(
        child: Text(
          'Le tue schede predefinite!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CreaSchedaWidget(
                  exerciseDetails: {},
                  schedaPredefinita: true,
                  userId: widget.userId,
                  userRole: widget.userRole,
                  flagRichieste: false,
                  userIdRequest: '',
                  requestId: '',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
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
              CustomListViewSchede().MyCustomListViewSchedePredefinite(
                  context,
                  true,
                  'Admin',
                  widget.userId,
                  widget.flagRichiesta,
                  widget.requestId),
            ],
          ),
        ),
      ],
    );
  }
}
