import 'package:empty/modules/profile/screens/profile.dart';
import 'package:empty/modules/profile/screens/map.dart';
import 'package:empty/modules/reservations/screens/list';
import 'package:empty/modules/top/screens/list.dart';
import 'package:empty/navigation/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  late final SharedPreferences prefs;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    MapSample(),
    TopFiveScreen(),
    ReservationListScreen(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
  }

  Future<void> _checkTutorialStatus() async {
    prefs = await SharedPreferences.getInstance();
    final bool? tutorial = prefs.getBool('tutorial');
    if (tutorial == null || !tutorial) {
      // Navega al tutorial si no ha sido visto
      Navigator.pushReplacementNamed(context, '/tutorial');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top 5',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reservaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 229, 255),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
