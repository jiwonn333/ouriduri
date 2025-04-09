import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateSettingViewModel extends ChangeNotifier {
  static const _selectedDateKey = 'selectedDate';
  DateTime _selectedDate = DateTime.now(); // 초기값 현재 날짜로 설정
  bool _isLoading = false;

  DateTime get selectedDate => _selectedDate;

  bool get isLoading => _isLoading;

  String getFormattedDate() {
    // String year = _selectedDate.year.toString();
    // String month = _selectedDate.month.toString();
    // String day = _selectedDate.day.toString();
    // return '$year 년 $month 월 $day 일';

    return DateFormat('yyyy년 MM월 dd일').format(_selectedDate);
  }

  // 선택한 날짜 업데이트
  void updateSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  // 저장된 날짜 불러오기
  Future<void> loadSelectedDate() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_selectedDateKey);

    if (savedDate != null) {
      _selectedDate = DateTime.tryParse(savedDate) ?? DateTime.now();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 선택한 날짜 저장
  Future<void> saveSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedDateKey, _selectedDate.toIso8601String());
  }
}
