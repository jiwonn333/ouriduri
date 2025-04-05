import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/bucketlist/ui/list_screen.dart';
import 'package:ouriduri_couple_app/features/calendar/ui/calendar_screen.dart';
import 'package:ouriduri_couple_app/features/settings/ui/settings_screen.dart';
import 'package:ouriduri_couple_app/widgets/bottom_nav_bar.dart';

import '../features/home/ui/home_base_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
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
      bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
