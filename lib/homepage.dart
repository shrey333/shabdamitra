import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _selectedIndex = _storage.read('userType');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _list = [
    "Lessons",
    "Search",
    "Settings",
  ];
  final _listWidget = [
    const Center(child: Text("Lessons")),
    const Center(child: Text("Search")),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
      appBar: AppBar(
        title: Text(_list[_selectedIndex]),
        centerTitle: true,
      ),
      body: _listWidget[_selectedIndex],
    );
  }
}
