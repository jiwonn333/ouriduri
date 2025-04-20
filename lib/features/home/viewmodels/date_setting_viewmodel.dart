import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/couple_service.dart';

class DateSettingViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now(); // 초기값 현재 날짜로 설정
  bool _isLoading = false;
  final CoupleService _coupleService = CoupleService();

  DateTime get selectedDate => _selectedDate;

  bool get isLoading => _isLoading;

  String getFormattedDate() {
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
    String? coupleId = await _coupleService.getCurrentCoupleId();
    final savedDate = prefs.getString('$coupleId-anniversaryDate');

    if (savedDate != null) {
      _selectedDate = DateTime.tryParse(savedDate) ?? DateTime.now();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 선택한 날짜 저장
  Future<void> saveSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? coupleId = await _coupleService.getCurrentCoupleId();
    if (coupleId != null) {
      final selectedDateKey = '$coupleId-anniversaryDate';
      await prefs.setString(selectedDateKey, _selectedDate.toIso8601String());

      await FirebaseFirestore.instance
          .collection("couples")
          .doc(coupleId)
          .update({
        "anniversaryDate": _selectedDate.toIso8601String(),
      });
    }
  }
}
