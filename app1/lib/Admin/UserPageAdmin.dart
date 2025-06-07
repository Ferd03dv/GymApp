// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomListViewSchedeCorsi.dart';
import 'package:gymfit/CustomItem/CustomScrollItem.dart';
import 'package:gymfit/Providers/UsersProvider.dart';
import 'package:provider/provider.dart';

class UserPageAdmin extends StatelessWidget {
  final String userId;
  final String userRole;
  final String username;
  final String email;

  final CustomScrollItem csw = CustomScrollItem();

  UserPageAdmin({
    super.key,
    required this.email,
    required this.userId,
    required this.userRole,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(userProvider, context),
        body: _buildBody(userProvider, context));
  }

  PreferredSizeWidget _buildAppBar(
      UsersProvider userProvider, BuildContext context) {
    return AppBar(
      title: Text(
        username,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildBody(UsersProvider userProvider, BuildContext context) {
    bool flag = true;

    return Stack(
      children: [
        const BackgroundContainer(),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    csw.MyCustomScrollItem(
                      context: context,
                      testo: "Crea Scheda",
                      icon: Icons.add_box_rounded,
                      color: Colors.black,
                      userId: userId,
                      userRole: 'Admin',
                      email: email,
                      nav: true,
                      delete: false,
                    ),
                    csw.MyCustomScrollItem(
                      context: context,
                      testo: "Cancella Account",
                      icon: Icons.delete_forever,
                      color: Colors.red,
                      userId: userId,
                      userRole: 'Admin',
                      email: email,
                      nav: false,
                      delete: true,
                    ),
                  ],
                ),
              ),
              CustomListViewSchede()
                  .MyCustomListViewSchede(context, userId, flag, userRole),
            ],
          ),
        ),
      ],
    );
  }
}
