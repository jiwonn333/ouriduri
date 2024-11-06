import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateSettingPage extends StatefulWidget {
  @override
  State<DateSettingPage> createState() => _DateSettingPageState();
}

class _DateSettingPageState extends State<DateSettingPage> {
  DateTime? _selectedDate;

  // Firebase Auth UID 가져오기
  Future<String?> getUserUID() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user?.uid;
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedDate(); // 저장된 날짜 불러오기
  }

  // 저장된 날짜 불러오기
  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = await getUserUID();

    // UID로 저장된 날짜 가져오기
    String? savedDate = prefs.getString(uid ?? '');

    if (savedDate != null) {
      setState(() {
        _selectedDate = DateTime.parse(savedDate); // 불러온 날짜를 DateTime으로 변환
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              _buildSelectedDateText(),
              SizedBox(height: 8),
              _buildDatePicker(),
              SizedBox(height: 10),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 선택된 날짜 표시를 위한 텍스트 생성 메서드
  String _getFormattedDate() {
    String year = _selectedDate?.year.toString() ?? 'XXXX';
    String month = _selectedDate?.month.toString() ?? 'XX';
    String day = _selectedDate?.day.toString() ?? 'XX';
    return '$year 년 $month 월 $day 일';
  }

  // 상단 앱바
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("OuriDuri"),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  // 타이틀 텍스트
  Widget _buildTitle() {
    return const Text('우리의 기념일',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
  }

  // 선택된 날짜 표시
  Widget _buildSelectedDateText() {
    return Text(
      _getFormattedDate(),
      style: const TextStyle(fontSize: 30, color: AppColors.primaryPink),
    );
  }

  // 날짜 선택을 위한 DatePicker
  Widget _buildDatePicker() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
        minimumDate: DateTime(1900),
        maximumDate: DateTime.now(),
        dateOrder: DatePickerDateOrder.ymd, // 기본 날짜 형식 순서 지정
      ),
    );
  }

  // 확인 버튼
  Widget _buildConfirmButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPink, // 배경색 지정
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 8),
        child: const Text(
          '확인',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'Ouriduri'), // 텍스트 색상 흰색으로
        ),
        onPressed: () {
          _saveSelectedDate();
          Navigator.pop(context, _selectedDate);
        },
      ),
    );
  }

  // SharedPreferences
  Future<void> _saveSelectedDate() async {
    if (_selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      String? uid = await getUserUID();
      prefs.setString(uid ?? '', _selectedDate!.toIso8601String());
      String formattedDate = _getFormattedDate();
      prefs.setString('${uid}_formatted', formattedDate);
    }
  }
}
