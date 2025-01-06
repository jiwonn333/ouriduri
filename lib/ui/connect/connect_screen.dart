import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';

import '../../utils/app_colors.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  @override
  void initState() {
    super.initState();
    _inviteCode = generateRandomCode(); // 랜덤 코드 생성
  }
  String _inviteCode = '';

  // 랜덤 코드 생성 메서드
  String generateRandomCode({int length = 9}) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: 'OuriDuri', bgColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRequestConnectionSection(),
            const SizedBox(height: 40),
            _buildRespondConnectionSection(),
          ],
        ),
      ),
    );
  }

  // 연결 요청하기 섹션
  Widget _buildRequestConnectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "초대 코드 공유하여 상대방과 연결해보세요!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
          Center(
            child: Text(
              "초대 코드: $_inviteCode",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(240, 46),
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
              ),
              backgroundColor: AppColors.primaryPink,
            ),
            child: const Text(
              "공유 하기",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 연결 요청 응답하기 섹션
  Widget _buildRespondConnectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "상대방의 코드를 알고 계신가요?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: "초대 코드 입력",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // 초대 코드 확인 로직 추가
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text("연결 확인"),
          ),
        ),
      ],
    );
  }
}
