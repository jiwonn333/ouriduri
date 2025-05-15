import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/**
 * 직접 통신만 담당하는 클래스
 */
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 기존 이메일 로그인
  Future<User?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  // ID 기반 로그인: id로 email 조회 후 로그인
  Future<User?> signInWithId(String id, String password) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      final data = query.docs.first.data();
      final email = data['email'];
      if (email == null) {
        return null;
      }

      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("❌ ID 기반 로그인 실패: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<void> signOut() async => await _auth.signOut();

  User? getCurrentUser() => _auth.currentUser;

  Future<bool> isLoggedIn() async => _auth.currentUser != null;

  /// 로그인 여부 확인
  static Future<bool> isUserLoggedIn() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // 앱이 삭제되었거나 세션이 유효하지 않으면 로그인된 사용자 정보는 null
      if (user == null) return false;
      await user.reload();
      return FirebaseAuth.instance.currentUser != null;
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }

  /// 커플 연결 상태 확인
  static Future<bool> isUserConnected() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return (doc.data()?['isConnected'] ?? false) as bool;
    } catch (e) {
      return false;
    }
  }
}
