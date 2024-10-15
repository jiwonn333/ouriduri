import 'package:flutter/cupertino.dart';

class JoinValidate {
  // focusNode 사용 전
  // 이메일 유효성 검사
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    } else {
      String pattern =
          r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(pattern);

      if (!regex.hasMatch(value)) {
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  // 아이디 유효성 검사
  String? validateId(String? value) {
    if (value == null || value.isEmpty) {
      return '아이디를 입력하세요';
    }
    return null;
  }

  // 비밀번호 유효성 검사
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자리 이상이어야 합니다';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      }
    }
    return null;
  }

  // 비밀번호 확인
  String? validatePasswordConfirm(String? value, TextEditingController _passwordController) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 다시 입력하세요';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }
}
