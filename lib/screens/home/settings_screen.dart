import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/screens/onboarding/start_screen.dart';
import 'package:ouriduri_couple_app/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '환경설정 화면',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () async {
              await _authService.signOut(context);
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
}
