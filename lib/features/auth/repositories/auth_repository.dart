import 'package:ouriduri_couple_app/core/services/firebase_service.dart';

/**
 * 앱 전용 인증 로직 제공
 */
class AuthRepository {
  final FirebaseService _firebaseService;

  AuthRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  // ID 기반 로그인
  Future<bool> loginWithId(String id, String password) async {
    try {
      final user = await _firebaseService.signInWithId(id, password);
      return user != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async => await _firebaseService.signOut();

  bool get isLoggedIn => _firebaseService.getCurrentUser() != null;
}
