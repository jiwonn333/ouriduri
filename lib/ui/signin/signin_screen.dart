import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/interface/signin_listener.dart';
import 'package:ouriduri_couple_app/services/firestore_service.dart';
import 'package:ouriduri_couple_app/ui/connect/request_screen.dart';
import 'package:ouriduri_couple_app/ui/intro/home_screen.dart';
import 'package:ouriduri_couple_app/ui/signin/signin_screen_viewmodel.dart';
import 'package:ouriduri_couple_app/widgets/custom_dialog.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import 'reset_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> implements SignInListener {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final SignInScreenViewModel _viewModel = SignInScreenViewModel(
      authService: AuthService(), fireStoreService: FireStoreService());

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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 24.0),
                      // id
                      CustomTextFormField(
                        controller: _idController,
                        hintText: "아이디",
                        icon: const Icon(Icons.person),
                        obscureText: false,
                        validator: (value) {},
                      ),
                      const SizedBox(height: 16.0),
                      // pw
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "비밀번호",
                        icon: const Icon(Icons.key),
                        obscureText: true,
                        validator: (value) {},
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
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),
                      // 로그인 버튼
                      CustomElevatedButton(
                          isValidated: true,
                          onPressed: () {
                            _viewModel.signIn(_idController.text,
                                _passwordController.text, this);
                          },
                          btnText: "로그인"),
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

  @override
  void onLoginFailed() {
    // 로그인 실패 시 사용자에게 알림
    showCupertinoDialog(
      context: context,
      builder: (context) => const CustomDialog("아이디 또는 비밀번호가 일치하지 않습니다."),
    );
  }

  @override
  void onLoginSuccess() async {
    print("로그인 성공");

    try {
      bool isConnected = await _viewModel.checkedConnection(_idController.text);

      if (isConnected) {
        // 연결된 상태이면 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // 연결되지 않은 상태이면 연결 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RequestScreen()),
        );
      }
    } catch (e) {
      print("연결 상태 확인 중 오류 발생: $e");
    }
  }

  @override
  void onNoRegisterEmail() {
    // 이메일 미등록 시 사용자에게 알림
    showCupertinoDialog(
      context: context,
      builder: (context) =>
          const CustomDialog("등록된 이메일이 없습니다. \n 회원가입을 먼저 진행해 주세요."),
    );
  }

  @override
  void onValidationError() {
    // 유효성 검사 실패 시 사용자에게 알림을 표시
    showCupertinoDialog(
      context: context,
      builder: (context) => const CustomDialog("아이디 또는 비밀번호가 잘못되었습니다."),
    );
  }

  Future<bool> _checkConnection(String userId) async {
    try {
      // Firestore에서 사용자의 연결 상태를 확인
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // 연결 상태가 true이면 연결된 상태
      if (userDoc.exists && userDoc.data() != null) {
        bool isConnected = userDoc['isConnected'] ?? false;
        return isConnected;
      } else {
        return false; // 연결 상태가 없거나 문서가 존재하지 않으면 false
      }
    } catch (e) {
      print("Error checking connection: $e");
      return false; // 오류가 발생하면 연결되지 않은 상태로 간주
    }
  }
}
