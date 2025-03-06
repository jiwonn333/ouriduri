import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

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

  Future<bool> checkedConnection(String uid) async {
    bool isConnected = await _fireStoreService.checkConnection(uid);
    return isConnected;
  }

  Future<String?> signIn(String id, String pw) async {
    // id, pw 유효성 검사
    if (!isValidCredentials(id, pw)) {
      return "아이디 또는 비밀번호가 잘못되었습니다.";
    }

    // 아이디를 통한 이메일 등록 여부 검사
    String? email = await _fireStoreService.getEmailFromUserId(id);
    if (email == null) {
      return "등록된 이메일이 없습니다. \n 회원가입을 먼저 진행해 주세요.";
    }

    // 이메일이 등록되어있는 경우 Firebase Auth 로그인 요청
    try {
      final user = await _authService.signIn(email, pw);
      if (user == null) {
        return "아이디 또는 비밀번호가 일치하지 않습니다.";
      }

      bool isConnected = await _fireStoreService.checkConnection(id);
      return isConnected ? "CONNECTED" : "NOT_CONNECTED";
    } catch (e) {
      print("로그인 실패: $e");
      return "로그인 중 오류가 발생했습니다.";
    }
  }

  /// 아이디 및 비밀번호 유효성 검사
  bool isValidCredentials(String id, String pw) {
    return id.isNotEmpty &&
        pw.isNotEmpty &&
        pw.length >= 8 &&
        !id.contains(' ');
  }
}
