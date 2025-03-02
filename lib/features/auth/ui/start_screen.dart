import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/start_buttons.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/start_footer.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/start_logo.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity, // 화면 가로 꽉 채우기
        height: double.infinity, // 화면 세로 꽉 채우기
        color: Colors.white, // 기본 배경 색
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const StartLogo(),
            const SizedBox(height: 30),
            StartButtons(),
            const SizedBox(height: 40),
            const StartFooter(),
          ],
        ),
      ),
    );
  }
}
