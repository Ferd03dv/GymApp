// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymfit/Admin/ListViewUtenti.dart';
import 'package:gymfit/Admin/NuoviAccount.dart';
import 'package:gymfit/Admin/SchedePredefinte.dart';
import 'package:gymfit/Pagine/Corsi.dart';
import 'package:gymfit/Pagine/Dashboard.dart';
import 'package:gymfit/Pagine/Richieste.dart';
import 'package:gymfit/Profilo/Profilo.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarAdmin extends StatefulWidget {
  final String username;
  final String currentUserId;
  final String userRole;
  final String email;

  const NavBarAdmin(
      {required this.username,
      required this.currentUserId,
      required this.userRole,
      required this.email,
      super.key});

  @override
  State<NavBarAdmin> createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  int _index = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ListViewUtenti(
        userId: widget.currentUserId,
        userRole: widget.userRole,
      ),
      NuoviAccount(
        userRole: widget.userRole,
      ),
      SchedePredefinite(
        userId: widget.currentUserId,
        userRole: widget.userRole,
        flagRichiesta: false,
        requestId: '',
      ),
      Corsi(
        userId: widget.currentUserId,
        email: widget.email,
        userRole: widget.userRole,
        username: widget.username,
      ),
      ProfiloWidget(
        currentUserId: widget.currentUserId,
        userRole: widget.userRole,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: GNav(
        style: GnavStyle.google,
        haptic: true,
        curve: Curves.bounceIn,
        backgroundColor: const Color.fromARGB(
            255, 219, 237, 14), // Cambia lo sfondo della nav bar
        color: Colors.white, // Colore delle icone non selezionate
        activeColor: Colors.black, // Colore delle icone selezionate
        tabBackgroundColor: const Color.fromARGB(
            255, 151, 163, 11), // Colore di sfondo delle schede attive
        gap: 4, // Riduci il gap tra icone e testo
        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20), // Adatta il padding per occupare più spazio
        selectedIndex: _index,
        onTabChange: (index) {
          setState(() {
            _index = index;
          });
        },
        tabs: const [
          GButton(
            icon: Icons.people,
            text: 'Utenti',
          ),
          GButton(
            icon: Icons.add_box_rounded,
            text: 'Nuovi Account',
          ),
          GButton(
            icon: Icons.assignment,
            text: 'Schede',
          ),
          GButton(
            icon: Icons.people,
            text: 'Corsi',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profilo',
          ),
        ],
      ),
    );
  }
}

class NavBarUser extends StatefulWidget {
  final String username;
  final String currentUserId;
  final String userRole;
  final String email;

  const NavBarUser(
      {required this.username,
      required this.currentUserId,
      required this.userRole,
      required this.email,
      super.key});

  @override
  State<NavBarUser> createState() => _NavBarUserState();
}

class _NavBarUserState extends State<NavBarUser> {
  final TextEditingController repsController = TextEditingController(text: '8');
  final TextEditingController setsController = TextEditingController(text: '3');
  final TextEditingController timerController =
      TextEditingController(text: '60');
  int _index = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardWidget(userId: widget.currentUserId, userRole: widget.userRole),
      Corsi(
        userId: widget.currentUserId,
        email: widget.email,
        userRole: widget.userRole,
        username: widget.username,
      ),
      Richieste(
        userId: widget.currentUserId,
        userRole: widget.userRole,
      ),
      ProfiloWidget(
        currentUserId: widget.currentUserId,
        userRole: widget.userRole,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_index],
      bottomNavigationBar: GNav(
        style: GnavStyle.google,
        haptic: true,
        curve: Curves.bounceIn,
        backgroundColor: const Color.fromARGB(
            255, 219, 237, 14), // Cambia lo sfondo della nav bar
        color: Colors.white, // Colore delle icone non selezionate
        activeColor: Colors.black, // Colore delle icone selezionate
        tabBackgroundColor: const Color.fromARGB(
            255, 151, 163, 11), // Colore di sfondo delle schede attive
        gap: 4, // Riduci il gap tra icone e testo
        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20), // Adatta il padding per occupare più spazio
        selectedIndex: _index,
        onTabChange: (index) {
          setState(() {
            _index = index;
          });
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Dashboard',
          ),
          GButton(
            icon: Icons.people,
            text: 'Corsi',
          ),
          GButton(
            icon: Icons.assignment,
            text: 'Richieste',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profilo',
          ),
        ],
      ),
    );
  }
}
