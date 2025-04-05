import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBaseViewModel with ChangeNotifier {
  DateTime? _startDate;
  String? _userName;
  String? _partnerName;
  bool _isLoading = false;

  DateTime? get startDate => _startDate;

  String? get userName => _userName;

  String? get partnerName => _partnerName;

  bool get isLoading => _isLoading;

  HomeBaseViewModel() {
    loadUserData();
  }

  /// 사용자 데이터 불러오기
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners(); // 로딩 시작 UI 반영

    final prefs = await SharedPreferences.getInstance();

    // 전체 데이터 로그 출력
    final allKeys = prefs.getKeys();
    for (var key in allKeys) {
      print('%key :  ${prefs.get(key)}');
    }

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // 1. 캐시된 데이터 불러오기
    _userName = prefs.getString('userName');
    _partnerName = prefs.getString('partnerName');
    String? savedDate = prefs.getString('$uid-startDate');
    _startDate = savedDate != null ? DateTime.parse(savedDate) : null;
    notifyListeners(); // 캐시 데이터 선 반영

    // 2. Firebase에서 유저 문서 가져오기
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        _userName = data['nickname'] as String?;
        await prefs.setString('userName', _userName ?? '');

        String? partnerUid = data['partnerUid'] as String?;
        if (partnerUid != null) {
          // 파트너 닉네임 가져오기
          final partnerDoc = await FirebaseFirestore.instance.collection(
              'users').doc(partnerUid).get();
          if (partnerDoc.exists) {
            final partnerData = partnerDoc.data();
            _partnerName = partnerData?['nickname'] as String?;
            await prefs.setString('partnerName', _partnerName ?? '');
          }
        }
      }
    }

      _isLoading = false;
    notifyListeners(); // 최종 UI 반영
  }

  /// 연애 시작일 저장
  Future<void> saveStartDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await prefs.setString('$uid-startDate', date.toIso8601String());
    }
    _startDate = date;
    notifyListeners(); // UI 업데이트
  }
}
