import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../service/auth_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          title: const Text(
        "비밀번호 재설정",
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration("이메일주소", const Icon(Icons.email)),
            ),
            const SizedBox(height: 16),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                authService.sendPasswordResetEmail(email);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("비밀번호 재설정 이메일을 보냈습니다.")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                '재생성 이메일 보내기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
