import 'package:ouriduri_couple_app/services/auth_service.dart';
import 'package:ouriduri_couple_app/services/firestore_service.dart';

import '../../interface/signin_listener.dart';

/**
 * SignInScreenViewModel: UI의 데이터 및 로직 처리 담당
 * 로그인 요청 관련 데이터 처리 및 비즈니스 로직 수행
 */

class SignInScreenViewModel {
  final AuthService _authService;
  final FireStoreService _fireStoreService;

  SignInScreenViewModel(
      {required AuthService authService,
      required FireStoreService fireStoreService})
      : _authService = authService,
        _fireStoreService = fireStoreService;

  Future<void> signIn(String id, String pw, SignInListener listener) async {
    // id, pw 유효성 검사
    if (!_isValidCredentials(id, pw)) {
      listener.onValidationError();
      return;
    }

    // 아이디를 통한 이메일 등록 여부 검사
    String? email = await _fireStoreService.getEmailFromUserId(id);
    if (email == null) {
      listener.onNoRegisterEmail();
      return;
    }

    // 이메일이 등록되어있는 경우 Firebase Auth 로그인 요청
    try {
      final user = await _authService.signIn(email, pw);
      if (user != null) {
        listener.onLoginSuccess();
      } else {
        listener.onLoginFailed();
      }
    } catch (e) {
      print("로그인 실패: $e");
      listener.onLoginFailed(); // 에러 발생 시 호출
    }
  }

  bool _isValidCredentials(String id, String pw) {
    // 유효성 검증 로직 예시
    if (id.isEmpty || pw.isEmpty || pw.length < 8 || id.contains(' ')) {
      return false;
    }
    return true;
  }
}
