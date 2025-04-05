import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateSettingViewModel with ChangeNotifier {
  DateTime _selectedDate = DateTime(2000, 1, 1);
  bool _isLoading = true; // 로딩 상태 변수

  DateTime get selectedDate => _selectedDate;

  bool get isLoading => _isLoading; // 로딩 상태 반환

  DateSettingViewModel() {
    loadSelectedDate();
  }

  Future<String?> _getUserUID() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      return user?.uid;
    } catch (e) {
      debugPrint("Error getting user UID: $e");
      return null;
    }
  }

  Future<void> loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = await _getUserUID();

    if (uid != null) {
      String? savedDate = prefs.getString(uid);
      if (savedDate != null) {
        _selectedDate = DateTime.parse(savedDate);
      }
    }

    _isLoading = false;
    notifyListeners(); // UI 갱신
  }

  Future<void> saveSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = await _getUserUID();

    if (uid != null) {
      prefs.setString('$uid-startDate', _selectedDate.toIso8601String());
      // String formattedDate = getFormattedDate();
      // prefs.setString('${uid}_formatted', formattedDate);
    }
  }

  void updateSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners(); // UI 갱신
  }

  String getFormattedDate() {
    String year = _selectedDate.year.toString();
    String month = _selectedDate.month.toString();
    String day = _selectedDate.day.toString();
    return '$year 년 $month 월 $day 일';
  }
}
