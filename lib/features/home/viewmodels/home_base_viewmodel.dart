import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBaseViewModel with ChangeNotifier {
  late DateTime _startDate;
  DateTime get startDate => _startDate;


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

  // 저장된 기념일 불러오기
  Future<void> _loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = await _getUserUID();
    String? savedDate = prefs.getString(uid ?? '');
    if (savedDate != null) {
      _startDate = DateTime.parse(savedDate);
    }
    notifyListeners();
  }
}
