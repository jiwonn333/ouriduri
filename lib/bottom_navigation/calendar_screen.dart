import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        titleTextStyle: const TextStyle(
            fontSize: 28, fontFamily: 'Ouriduri', color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDate,
            // 현재 보고있는 날짜
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            //선택된 날짜를 확인하고 스타일을 적용
            onDaySelected: (selectedDay, focusedDay) {
              // 날짜가 선택되었을 때의 동작
              setState(() {
                _selectedDate = selectedDay;
                _focusedDate = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              //  오늘 날짜와 선택된 날짜의 색상 등을 조정
              todayDecoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) =>
                  DateFormat.MMMM(locale).format(date), // 월만 표시
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              leftChevronVisible: false,
              rightChevronVisible: false
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '선택된 날짜: ${_selectedDate.toLocal()}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
