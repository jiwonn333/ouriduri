import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ouriduri_couple_app/core/services/couple_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<String>> events = {};
  final CoupleService _coupleService = CoupleService();

  CalendarViewModel() {
    loadEvents();
  }

  // 날짜 선택 시 호출
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay = _getDateOnly(selected);
    focusedDay = _getDateOnly(focused);
    notifyListeners();
  }

  // 캘린더 형식 변경
  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat = format;
      notifyListeners();
    }
  }

  // 페이지 이동 시 포커스 날짜 변경
  void onPageChanged(DateTime focusedDate) {
    focusedDay = _getDateOnly(focusedDate);
  }

  // 이벤트 추가 다이얼로그 호출
  void addEventDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("이벤트 추가"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "이벤트 내용을 입력하세요"),
        ),
        actions: [
          TextButton(
            child: const Text("취소"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("저장"),
            onPressed: () {
              _saveEvent(controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // 이벤트 저장
  Future<void> _saveEvent(String event) async {
    if (event.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    // final uid = await _getUserUID();
    // if (uid == null) return;

    final coupleId = await _coupleService.getCurrentCoupleId();
    if(coupleId == null) return;

    final dateOnly = _getDateOnly(selectedDay);
    final key = '$coupleId-${_formatDate(dateOnly)}';

    events.putIfAbsent(dateOnly, () => []).add(event);
    await prefs.setStringList(key, events[dateOnly]!);
    notifyListeners();
  }

  // 이벤트 삭제 다이얼로그
  void confirmDeleteEvent(BuildContext context, String event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("이벤트 삭제"),
        content: const Text("이벤트를 삭제하시겠습니까?"),
        actions: [
          TextButton(
            child: const Text("취소"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("삭제"),
            onPressed: () {
              _deleteEvent(event);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // 이벤트 삭제
  Future<void> _deleteEvent(String event) async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = await _coupleService.getCurrentCoupleId();
    if (coupleId == null) return;

    final dateOnly = _getDateOnly(selectedDay);
    final key = '$coupleId-${_formatDate(dateOnly)}';

    events[dateOnly]?.remove(event);
    if (events[dateOnly]?.isEmpty ?? true) {
      events.remove(dateOnly);
      await prefs.remove(key);
    } else {
      await prefs.setStringList(key, events[dateOnly]!);
    }
    notifyListeners();
  }

  // 이벤트 불러오기
  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = await _coupleService.getCurrentCoupleId();
    if (coupleId == null) return;

    final loaded = <DateTime, List<String>>{};
    for (final key in prefs.getKeys()) {
      final parts = key.split('-');
      if (parts.length < 2 || parts[0] != coupleId) continue;
      if (!_isValidDate(parts[1])) continue;

      final date = _parseDate(parts[1]);
      loaded[date] = prefs.getStringList(key) ?? [];
    }

    events = loaded;
    notifyListeners();
  }

  // 날짜 포맷 변환
  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  DateTime _parseDate(String formatted) {
    return _getDateOnly(DateFormat('yyyy/MM/dd').parse(formatted));
  }

  DateTime _getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isValidDate(String value) {
    try {
      DateFormat('yyyy/MM/dd').parse(value);
      return true;
    } catch (_) {
      return false;
    }
  }
}
