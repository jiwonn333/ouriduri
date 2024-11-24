import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/start_scrren.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '환경설정 화면',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () async {
              await _signOut(context);
            },
            child: const Text(
              '로그아웃',
              style: TextStyle(fontSize: 18, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  // 로그아웃
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // 로그아웃 후 로그인 화면으로 이동하고 이전 화면 제거
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
        // LoginPage를 임포트한 후 사용
        (route) => false,
      );
    } catch (e) {
      // 로그아웃 과정에서 오류가 발생한 경우 사용자에게 알림을 제공
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("로그아웃 중 오류가 발생했습니다."),
        ),
      );
    }
  }
}
