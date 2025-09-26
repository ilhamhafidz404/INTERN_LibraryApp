import 'package:flutter/material.dart';
import 'package:intern_libraryapp/pages/student/home_page.dart';
import 'package:intern_libraryapp/pages/student/profile/profile_page.dart';
import 'package:intern_libraryapp/pages/student/search_page.dart';

class MainPageWithIndex extends StatefulWidget {
  final int initialIndex;
  const MainPageWithIndex({super.key, this.initialIndex = 0});

  @override
  State<MainPageWithIndex> createState() => _MainPageWithIndexState();
}

class _MainPageWithIndexState extends State<MainPageWithIndex> {
  late int _currentIndex;

  final List<Widget> _pages = const [HomePage(), SearchPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Color(0xFFed5d5e),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
