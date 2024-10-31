import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/date_setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildHeader(),
      ),
    );
  }

  int calculateLoveDays(DateTime startDate) {
    final currentDate = DateTime.now();
    return currentDate.difference(startDate).inDays;
  }

  // 상단 디데이
  Widget _buildHeader() {
    int loveDays = startDate != null ? calculateLoveDays(startDate!) : 0;

    return Container(
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
                  Text('$loveDays', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(' 일 째', style: TextStyle(fontSize: 18)),
                ],
              ),

              // 2. 이름 (하트) 이름
              Row(
                children: [
                  Text('지원', style: TextStyle(fontSize: 18)),
                  Icon(Icons.favorite, color: Color(0xffff9094), size: 16),
                  Text('영건', style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),

          // 2. 아이콘
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right_rounded),
            onPressed: () async {
              final selectedDate = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DateSettingPage()),
              );
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
