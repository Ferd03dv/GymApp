// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomFloatingButton.dart';
import 'package:gymfit/CustomItem/CustomListViewSchedeCorsi.dart';

class DashboardWidget extends StatefulWidget {
  final String userId;
  final String userRole;

  const DashboardWidget(
      {super.key, required this.userId, required this.userRole});

  @override
  //ignore: library_private_types_in_public_api
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          final canRequestFocus = FocusScope.of(context).canRequestFocus;
          if (canRequestFocus) {
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(resizeToAvoidBottomInset: false, body: _buildBody()));
  }

  Widget _buildBody() {
    bool flag = false;
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Stack(children: [
          const BackgroundContainer(),
          SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Le tue schede',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                CustomListViewSchede().MyCustomListViewSchede(
                    context, widget.userId, flag, 'user')
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: MyFloatingActionButton(
          icon: Icons.add, userId: widget.userId, userRole: widget.userRole),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
