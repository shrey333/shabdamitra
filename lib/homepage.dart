import 'package:flutter/material.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/settings/settings.dart';
import 'package:shabdamitra/search/search.dart';
import 'package:shabdamitra/lessons/lessons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  _HomePageState() {
    if (ApplicationContext().isUserStudent()) {
      _selectedIndex = 0;
    } else {
      _selectedIndex = 1;
    }
  }

  final _listWidget = [
    const Lessons(),
    const Search(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _listWidget[_selectedIndex],
    );
  }
}
