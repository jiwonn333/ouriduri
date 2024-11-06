import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/bottom_navigation/calendar_screen.dart';
import 'package:ouriduri_couple_app/bottom_navigation/home_screen.dart';
import 'package:ouriduri_couple_app/bottom_navigation/list_screen.dart';
import 'package:ouriduri_couple_app/bottom_navigation/setting_screen.dart';

import 'app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 각 탭에 연결될 화면 리스트
  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    ListScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // 아이콘 선택시 다른 아이콘이 밀리지 않도록 고정
        selectedItemColor: AppColors.primaryPink,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
