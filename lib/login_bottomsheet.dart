import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/validate.dart';

import 'app_colors.dart';
import 'connect_page.dart';
import 'home.dart';
import 'login/reset_password_screen.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24.0),
                      // 로그인 타이틀
                      const Center(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // 아이디 입력필드
                      TextFormField(
                        controller: _idController,
                        decoration: _inputDecoration("아이디", Icon(Icons.person)),
                        validator: (value) => JoinValidate().validateId(value),
                      ),
                      const SizedBox(height: 16.0),
                      // 비밀번호 입력 필드
                      TextFormField(
                        controller: _passwordController,
                        decoration: _inputDecoration("비밀번호", Icon(Icons.key)),
                        obscureText: true,
                        validator: (value) => JoinValidate()
                            .validatePassword(value, _idController.text.trim()),
                      ),

                      const SizedBox(height: 16.0),
                      // 비밀번호 분실
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                          );
                        },
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            '비밀번호를 분실하셨나요?',
                            style: TextStyle(
                                color: AppColors.primaryDarkPink,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),
                      // 로그인 버튼
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                // 닫기 버튼
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      Navigator.pop(context); // Bottom Sheet 닫기
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    String? email = await _getEmailFromUserId(_idController.text);

    if (email != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: _passwordController.text);
        if (userCredential.user != null) {
          bool isConnected = await _checkConnection(userCredential.user!.uid);

          if (isConnected) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ConnectPage()));
          }
          print("로그인 성공");
        }
      } catch (e) {
        print("로그인실패: $e");
      }
    } else {
      print("해당 아이디에 대한 이메일을 찾을 수 없습니다.");
    }
  }

  // Firestore에서 아이디로 이메일 찾기
  Future<String?> _getEmailFromUserId(String userId) async {
    try {
      // 아이디로 firestore에서 이메일 찾기
      QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first['email']; // 이메일 반환
      } else {
        print('아이디가 존재하지 않음');
        return null;
      }
    } catch (e) {
      print("이메일 찾기 실패: $e");
      return null;
    }
  }

  // Firestore에서 커플 연결 여부 확인
  Future<bool> _checkConnection(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['isConnected'] == true;
      }
    } catch (e) {
      print("커플 연결 상태 확인 실패: $e");
    }
    return false;
  }
}

InputDecoration _inputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    hintText: hintText,
    border: _outlineInputBorder(),
    fillColor: Colors.grey.withOpacity(0.1),
    filled: true,
    prefixIcon: icon,
  );
}

OutlineInputBorder _outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );
}
