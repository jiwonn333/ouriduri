import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  /// 로그인 여부 확인
  static Future<bool> isUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    // 앱이 삭제되었거나 세션이 유효하지 않으면 로그인된 사용자 정보는 null
    if (user == null) {
      print("❗(firebase service) 로그인되지 않은 상태입니다.");
      return false;
    }
    if (user == null) {
      print("❌ 사용자 로그인되지 않음.");
      return false;
    }

    try {
      // 세션 갱신 후, 현재 사용자가 로그인된 상태인지 확인
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ 사용자 세션이 만료됨.");
        return false;
      }
      return true;
    } catch (e) {
      print("❌ FirebaseAuth 오류: $e");
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }

  /// 커플 연결 상태 확인
  static Future<bool> isUserConnected() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ 로그인된 사용자가 없습니다.");
      return false;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        print("❌ Firestore에서 사용자 정보 없음.");
        return false;
      }

      var data = doc.data() as Map<String, dynamic>;
      bool isConnected = data['isConnected'] ?? false;
      print("isConnected $isConnected");
      return isConnected;
    } catch (e) {
      print("❌ Firestore 오류: $e");
      return false;
    }
  }
}
