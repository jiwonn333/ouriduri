import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/forgot_password_button.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/signin_screen_viewmodel.dart';
import 'package:ouriduri_couple_app/navigation/main_navigation_screen.dart';
import 'package:ouriduri_couple_app/widgets/custom_dialog.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../connect/request_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                      const ForgotPasswordButton(),
                      const SizedBox(height: 24.0),
                      // 로그인 버튼
                      CustomElevatedButton(
                          isValidated: true,
                          onPressed: _handleSignIn,
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

  /// 로그인 버튼 클릭 시 처리
  Future<void> _handleSignIn() async {
    String? result = await _viewModel.signIn(
      _idController.text,
      _passwordController.text,
    );

    if (result == "CONNECTED") {
      _navigateToMain();
    } else if (result == "NOT_CONNECTED") {
      _navigateToRequest();
    } else {
      CustomDialog.show(context, result!);
    }
  }

  /// 홈 화면 이동
  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  /// 연결 요청 화면 이동
  void _navigateToRequest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RequestScreen()),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
