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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      if (ApplicationContext().isUserStudent()) const Lessons(),
      const Search(),
      Settings(onChange: () {
        setState(() {
          if (ApplicationContext().isUserStudent()) {
            _selectedIndex = 2;
          } else {
            _selectedIndex = 1;
          }
        });
      }),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: <BottomNavigationBarItem>[
          if (ApplicationContext().isUserStudent())
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Lessons',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: widgets[_selectedIndex],
    );
  }
}
