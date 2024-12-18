import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/ui/signup/terms_bottom_sheet.dart';
import 'package:ouriduri_couple_app/ui/signin/signin_screen.dart';

import '../../utils/app_colors.dart';
/**
 * UI 담당
 * 오직 화면만 그림
 */

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 30),
                  _buildButtons(),
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
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
            textColor: AppColors.primaryDarkPink),
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
        minimumSize: const Size(230, 45),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ouriduri',
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
