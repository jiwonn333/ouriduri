class JoinValidate {
  // 정규식 상수화
  // r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}$'
  static const String _emailPattern =
      r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$";

  static const String _passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';

  // 허용 도메인 목록
  final List<String> allowedDomains = [
    'gmail.com',
    'naver.com',
    'daum.net',
    'hanmail.net'
  ];

  // 이메일 유효성 검사
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }

    final regex = RegExp(_emailPattern);
    if (!regex.hasMatch(value)) {
      return '잘못된 이메일 형식입니다.';
    }

    // 도메인 확인
    String domain = value.split('@').last;
    if (!allowedDomains.contains(domain)) {
      return '이메일을 다시한번 확인해주세요';
    }
    return null;
  }

  // 아이디 유효성 검사
  String? validateId(String? value) {
    final RegExp idRegEx = RegExp(r"^[a-zA-Z0-9]{4,12}$");
    if (value!.isEmpty) {
      return "아이디를 입력해주세요.";
    }
    if (!idRegEx.hasMatch(value)) {
      return "아이디는 4~12자의 영문 또는 숫자만 가능합니다.";
    }
    return null; // 유효하면 null 반환
  }

  // 비밀번호 유효성 검사
  String? validatePassword(String? password, String? id) {
    if (password == null || password.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    if (password.length < 8) {
      return '비밀번호는 최소 8자리 이상이어야 합니다.';
    }

    // 비밀번호 형식 확인
    final regex = RegExp(_passwordPattern);
    if (!regex.hasMatch(password)) {
      return '특수문자, 대소문자, 숫자 포함 8자리 이상 15자 이내로 입력해주세요.';
    }

    // 아이디와 비밀번호가 같은지
    if (password == id) {
      return '아이디와 비밀번호는 같을 수 없습니다.';
    }

    return null;
  }

  // 비밀번호 확인
  String? validatePasswordConfirm(String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return '비밀번호를 다시 입력하세요';
    }
    if (confirmPassword != password) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  String? validateNickname(String? nickname) {
    if (nickname == null || nickname.isEmpty) {
      return '닉네임을 입력해주세요';
    }

    final regex = RegExp(r'^[a-zA-Z0-9가-힣_.]{2,12}$');
    // 한글, 영문, 숫자, _ . 허용 (2~12자)

    if (!regex.hasMatch(nickname)) {
      return '12자 이내로 입력해주세요.';
    }

    return null;
  }
}
