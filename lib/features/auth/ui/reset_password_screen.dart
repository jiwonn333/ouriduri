import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../../../core/services/auth_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  final AuthService _authService = AuthService();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "비밀번호 재설정", bgColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
                controller: _emailController,
                hintText: "이메일",
                icon: const Icon(Icons.email),
                obscureText: false,
                validator: (value) {}),
            const SizedBox(height: 16),

            // 로그인 버튼
            CustomElevatedButton(
                isValidated: true,
                onPressed: () {
                  final email = _emailController.text.trim();
                  _authService.sendPasswordResetEmail(email);
                },
                btnText: "재생성 이메일 보내기")
          ],
        ),
      ),
    );
  }
}
