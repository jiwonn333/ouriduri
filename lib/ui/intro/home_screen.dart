import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/ui/navigation/calendar_screen.dart';
import 'package:ouriduri_couple_app/ui/navigation/home_base_screen.dart';
import 'package:ouriduri_couple_app/ui/navigation/list_screen.dart';
import 'package:ouriduri_couple_app/ui/navigation/settings_screen.dart';

import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 각 탭에 연결될 화면 리스트
  final List<Widget> _pages = <Widget>[
    const HomeBaseScreen(),
    const CalendarScreen(),
    const ListScreen(),
    const SettingsScreen(),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: AppColors.dividerLineColor, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          // 아이콘 선택시 다른 아이콘이 밀리지 않도록 고정
          selectedItemColor: AppColors.primaryPink,
          unselectedItemColor: Colors.black54,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
