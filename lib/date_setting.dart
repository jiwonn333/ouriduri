import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateSettingPage extends StatefulWidget {
  const DateSettingPage({super.key});

  @override
  State<DateSettingPage> createState() => _DateSettingPageState();
}

class _DateSettingPageState extends State<DateSettingPage> {
  DateTime? _selectedDate;

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
      style: const TextStyle(fontSize: 22, color: Color(0xffff9094)),
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
        color: Color(0xffd98c8e), // 배경색 지정
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
          Navigator.pop(context, _selectedDate);
        },
      ),
    );
  }
}
