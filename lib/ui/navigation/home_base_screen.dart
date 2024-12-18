import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/ui/navigation/date_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_colors.dart';
import 'date_setting_screen.dart';

class HomeBaseScreen extends StatefulWidget {
  const HomeBaseScreen({super.key});

  @override
  State<HomeBaseScreen> createState() => _HomeBaseScreenState();
}

class _HomeBaseScreenState extends State<HomeBaseScreen> {
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  // 저장된 기념일 불러오기
  Future<void> _loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = await _getUserUID();
    String? savedDate = prefs.getString(uid ?? '');
    if (savedDate != null) {
      setState(() {
        startDate = DateTime.parse(savedDate);
      });
    }
  }

  Future<String?> _getUserUID() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildHeader(),
      ),
    );
  }

  int calculateLoveDays(DateTime startDate) {
    final currentDate = DateTime.now();
    return currentDate.difference(startDate).inDays + 1;
  }

  // 상단 디데이
  Widget _buildHeader() {
    int loveDays = startDate != null ? calculateLoveDays(startDate!) : 0;

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 1. 텍스트
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. 사랑한 지 *** 일 째
              Row(
                children: [
                  Text('사랑한 지 ', style: TextStyle(fontSize: 18)),
                  Text('$loveDays',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(' 일 째', style: TextStyle(fontSize: 18)),
                ],
              ),

              // 2. 이름 (하트) 이름
              Row(
                children: [
                  Text('지원', style: TextStyle(fontSize: 18)),
                  Icon(Icons.favorite, color: AppColors.primaryPink, size: 16),
                  Text('영건', style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),

          // 2. 아이콘
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
            onPressed: () async {
              final selectedDate = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DateSettingPage()));
              if (selectedDate != null) {
                setState(() {
                  startDate = selectedDate;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
