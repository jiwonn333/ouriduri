import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/auth/ui/start_screen.dart';

/**
 * Firebase와 같은 외부 서비스와의 연동을 처리하는 로직을 포함
 * 인증 로직 (로그인, 회원가입 등)
 */
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 회원가입
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("회원가입 실패 : $e");
      return null;
    }
  }

  // 로그인
  Future<User?> signIn(String email, String password) async {
    // 중복 확인
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // 비밀번호 재설정
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error during password reset: $e");
    }
  }

  // 로그아웃
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // 로그아웃 후 로그인 화면으로 이동하고 이전 화면 제거
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
        // LoginPage를 임포트한 후 사용
        (route) => false,
      );
    } catch (e) {
      // 로그아웃 과정에서 오류가 발생한 경우 사용자에게 알림을 제공
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("로그아웃 중 오류가 발생했습니다."),
        ),
      );
    }
  }

  // 비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("비밀번호 재설정 이메일을 보냈습니다.");
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  // UID
  Future<String?> getUID() async {
    final User? user = _auth.currentUser;
    return user?.uid;
  }
}
