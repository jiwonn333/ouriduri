import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/couple_service.dart';
import '../../core/utils/app_colors.dart';
import '../../navigation/main_navigation_screen.dart';
import '../../widgets/custom_app_bar.dart';

class ResponseScreen extends StatefulWidget {
  final String? inviteCode;

  const ResponseScreen({Key? key, required this.inviteCode}) : super(key: key);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late TextEditingController _inviteCodeController;
  final CoupleService _coupleService = CoupleService();

  @override
  void initState() {
    super.initState();
    // 초대 코드 입력 컨트롤러 초기화 (딥링크 초대 코드가 있다면 기본값 설정)
    _inviteCodeController =
        TextEditingController(text: widget.inviteCode ?? "");
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: "초대 코드 입력", bgColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "초대 코드를 입력해주세요",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _inviteCodeController,
              decoration: const InputDecoration(
                labelText: "초대 코드",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _verifyInviteCode();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 46),
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
                ),
                backgroundColor: AppColors.primaryPink,
              ),
              child: const Text(
                "초대 코드 확인",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyInviteCode() async {
    String enteredCode = _inviteCodeController.text.trim();

    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("초대 코드를 입력하세요.")),
      );
      return;
    }

    try {
      // 파트너 UID 조회
      final partnerUid =
          await _coupleService.getPartnerUidByInviteCode(enteredCode);
      if (partnerUid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("올바르지 않은 초대 코드입니다.")),
        );
        return;
      }

      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUid == null) return;
      print("###RESPONSE_SCREEN### 현재 사용자: $currentUserUid, 파트너: $partnerUid");

      // 연결 처리
      await _coupleService.connectUsers(currentUserUid, partnerUid);

      // 커플 ID 생성 및 커플 문서 생성
      final coupleId = _coupleService.getCoupleId(currentUserUid, partnerUid);
      await _coupleService.createCoupleDocument(coupleId);

      print("✅ 커플 연결 완료!");

      // 커플 연결 성공 → `HomeScreen`으로 이동 & `RequestScreen`/`ResponseScreen` 제거
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print("🔥 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("오류가 발생했습니다. 다시 시도해주세요.")),
      );
    }
  }
}
