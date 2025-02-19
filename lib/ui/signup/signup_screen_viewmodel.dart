import 'package:ouriduri_couple_app/interface/signup_listener.dart';
import 'package:ouriduri_couple_app/services/auth_service.dart';
import 'package:ouriduri_couple_app/services/firestore_service.dart';

class SignUpScreenViewModel {
  final AuthService _authService;
  final FireStoreService _fireStoreService;

  SignUpScreenViewModel(
      {required AuthService authService,
      required FireStoreService fireStoreService})
      : _authService = authService,
        _fireStoreService = fireStoreService;

  Future<void> signUp(String id, String email, String password, String birthday,
      SignUpListener listener) async {
    // 아이디 중복 검사
    if (await _fireStoreService.isIdDuplicate(id)) {
      listener.onValidationError("idError");
      return;
    }

    // 이메일 중복 검사
    if (await _fireStoreService.isEmailDuplicate(email)) {
      listener.onValidationError("emailError");
      return;
    }

    // 중복 되어있지 않은 아이디와 이메일인 경우 Firebase Auth 회원가입 요청
    try {
      final user = await _authService.signUp(email, password);
      if (user != null) {
        // FireStore 회원 정보 저장 및 화면 닫기 요청
        _fireStoreService.saveUserData(user.uid, id, email, birthday);
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
