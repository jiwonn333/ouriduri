import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';
import 'package:ouriduri_couple_app/features/settings/ui/profile_edit_screen.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';

import '../../../core/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushNotificationEnabled = true; // 푸시 알림 상태

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "설정", bgColor: Colors.white),
      // appBar: AppBar(title: Text("설정")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("프로필 편집"),
            trailing: Icon(Icons.keyboard_arrow_right_outlined), // trailing 속성 사용
            onTap: goToProfileEdit,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("커플 정보 관리"),
            onTap: () {},
          ),
          SwitchListTile(
            title: Text("푸시 알림 설정"),
            secondary: Icon(Icons.notifications),
            value: isPushNotificationEnabled,
            onChanged: (bool value) {
              setState(() {
                isPushNotificationEnabled = value;
              });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("로그아웃", style: TextStyle(color: Colors.red)),
            onTap: () {
              AuthService().signOut(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("커플 연결 끊기", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// 프로필 편집 화면 이동
  void goToProfileEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditScreen()),
    );
  }
}