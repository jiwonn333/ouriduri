import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';

import '../reset_password_screen.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
