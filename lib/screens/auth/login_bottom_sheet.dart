import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/services/firestore_service.dart';
import 'package:ouriduri_couple_app/utils/validation_utils.dart';

import '../../connect_page.dart';
import '../../home.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import 'reset_password_screen.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FireStoreService _fireStoreService = FireStoreService();

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
                        validator: (value) =>
                            JoinValidate()
                                .validatePassword(value, _idController.text
                                .trim()),
                      ),

                      const SizedBox(height: 16.0),
                      // 비밀번호 분실
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()),
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
                        onPressed: _signIn,
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

  Future<void> _signIn() async {
    String? email = await _fireStoreService.getEmailFromUserId(
        _idController.text);

    if (email != null) {
      try {
        final user = await _authService.signIn(email, _passwordController.text);
        if (user != null) {
          // bool isConnected = await _checkConnection(userCredential.user!.uid);
          // if (isConnected) {
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const HomePage()));
          // } else {
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const ConnectPage()));
          // }
          print("로그인 성공");
        }
      } catch (e) {
        print("로그인실패: $e");
      }
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
}