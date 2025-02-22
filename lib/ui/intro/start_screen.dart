import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/signin_screen.dart';
import 'package:ouriduri_couple_app/features/auth/ui/terms_bottom_sheet.dart';

import '../../core/utils/app_colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity, // 화면 가로 꽉 채우기
        height: double.infinity, // 화면 세로 꽉 채우기
        color: Colors.white, // 기본 배경 색
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 상단 배치
          children: [
            _buildLogo(),
            const SizedBox(height: 30),
            _buildButtons(),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset('assets/login_logo.png'),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        _buildElevatedButton(
          label: "시작",
          onPressed: _showTermsBottomSheet,
          backgroundColor: Colors.white,
          borderColor: AppColors.primaryPink,
          textColor: AppColors.primaryDarkPink,
        ),
        const SizedBox(height: 10),
        _buildElevatedButton(
          label: "로그인",
          onPressed: _showLoginBottomSheet,
          backgroundColor: AppColors.primaryPink,
          borderColor: Colors.transparent,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      '@ouriduri',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(230, 46),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  void _showTermsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => const TermsBottomSheet(),
    );
  }

  void _showLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => const SignInScreen(),
    );
  }
}
