import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/bucketlist/ui/list_screen.dart';
import 'package:ouriduri_couple_app/features/calendar/ui/calendar_screen.dart';
import 'package:ouriduri_couple_app/features/calendar/viewmodels/calendar_veiwmodel.dart';
import 'package:ouriduri_couple_app/features/home/viewmodels/home_base_viewmodel.dart';
import 'package:ouriduri_couple_app/features/settings/ui/settings_screen.dart';
import 'package:ouriduri_couple_app/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../features/home/screens/home_base_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // 각 탭에 연결될 화면 리스트
  final List<Widget> _pages = <Widget>[
    ChangeNotifierProvider(
      create: (_) => HomeBaseViewModel(),
      child: const HomeBaseScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: const CalendarScreen(),
    ),
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
