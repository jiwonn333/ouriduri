import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ouriduri_couple_app/ui/navigation/home/date_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_colors.dart';

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
    // 현재 날짜 가져오기
    DateTime now = DateTime.now();
    // 현재 날짜를 기준으로 해당 주의 일요일 날짜 계산
    DateTime startOfWeek =
        now.subtract(Duration(days: now.weekday % 7)); // Sunday 기준으로 시작
    // 요일별 날짜 리스트 생성
    List<DateTime> weekDates =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    String year = now.year.toString();
    String month = now.month.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 26),
                Text(
                  "$year년 ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$month월",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
                thickness: 0.4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekDates.map((date) {
                bool isToday = now.day == date.day &&
                    now.month == date.month &&
                    now.year == date.year;
                String formattedDate = DateFormat('d').format(date); // 날짜만 추출
                String weekDay =
                    DateFormat('E', 'ko_KR').format(date); // 한글 요일 (월, 화 등)
                return Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 36, // 높이를 넉넉히 설정하여 점 포함
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            formattedDate, // 날짜 텍스트
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isToday
                                  ? Colors.pink
                                  : Colors.grey, // 현재 날짜는 핑크색, 나머지는 회색
                            ),
                          ),
                          if (isToday)
                            const Positioned(
                              top: 4, // 날짜 위에 점 위치 조정
                              child: Icon(Icons.circle,
                                  size: 6, color: AppColors.primaryDarkPink),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weekDay, // 요일 텍스트
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
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
                  const Text('사랑한 지  ', style: TextStyle(fontSize: 18)),
                  Text('$loveDays',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
