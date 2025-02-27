import 'package:ouriduri_couple_app/interface/signup_listener.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class SignUpScreenViewModel {
  final AuthService _authService;
  final FireStoreService _fireStoreService;

  SignUpScreenViewModel(
      {required AuthService authService,
        required FireStoreService fireStoreService})
      : _authService = authService,
        _fireStoreService = fireStoreService;

  // 아이디 중복 체크
  Future<bool> checkIdDuplicate(String id) async {
    return await _fireStoreService.isIdDuplicate(id);
  }

  // 이메일 중복 체크
  Future<bool> checkEmailDuplicate(String email) async {
    return await _fireStoreService.isEmailDuplicate(email);
  }

  Future<void> signUp(String id, String email, String password, String nickname,
      SignUpListener listener) async {

    // 중복 되어있지 않은 아이디와 이메일인 경우 Firebase Auth 회원가입 요청
    try {
      final user = await _authService.signUp(email, password);
      if (user != null) {
        // FireStore 회원 정보 저장 및 화면 닫기 요청
        _fireStoreService.saveUserData(user.uid, id, email, nickname, "");
        listener.onNavigatorPop();
      } else {
        // 회원가입 실패
        listener.onSignUpFailed();
      }
    } catch (e) {
      print("회원가입 중 오류 발생: $e");
      listener.onSignUpFailed();
    }
  }
}
