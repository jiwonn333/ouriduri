import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../navigation/main_navigation_screen.dart';

class ResponseScreen extends StatefulWidget {
  final String? inviteCode;

  const ResponseScreen({Key? key, required this.inviteCode}) : super(key: key);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late TextEditingController _inviteCodeController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              decoration: InputDecoration(
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
      // 초대 코드가 존재하는지 Firestore에서 확인
      QuerySnapshot inviteCodeQuery = await _firestore
          .collection("users")
          .where("inviteCode", isEqualTo: enteredCode)
          .limit(1)
          .get();

      if (inviteCodeQuery.docs.isNotEmpty) {
        // 초대 코드가 일치하는 사용자 찾기
        DocumentSnapshot userDoc = inviteCodeQuery.docs.first;
        String partnerUid = userDoc.id; // 상대방의 UID 가져오기
        print("상대방의 uid : $partnerUid");
        String partnerInviteCode = userDoc.get("inviteCode"); // 상대방의 초대 코드 가져오기

        // 현재 로그인 한 사용자의 uid
        User? user = FirebaseAuth.instance.currentUser;
        String? currentUserUid = user?.uid;
        if (currentUserUid == null) return;
        print("📢 현재 로그인된 유저: $currentUserUid");

        // Firestore에 isConnected 값을 true로 업데이트 (partner와 현재 로그인한 user)
        await _firestore.collection("users").doc(partnerUid).update({
          "isConnected": true,
          "partnerUid": currentUserUid,
          "inviteCode": FieldValue.delete(), // ✅ 초대 코드 삭제
        });

        await _firestore.collection("users").doc(currentUserUid).update({
          "isConnected": true,
          "partnerUid": partnerUid,
          "inviteCode": FieldValue.delete(), // ✅ 초대 코드 삭제
        });

        // ✅ 항상 같은 coupleId를 생성 (정렬 사용)
        List<String> sortedUid = [currentUserUid, partnerUid];
        sortedUid.sort();
        String coupleId = sortedUid.join("_");

        // 공유 데이터 저장할 문서 생성
        await _firestore.collection("sharedData").doc(coupleId).set({
          "calendar": [],
        });

        print("✅ 커플 연결 완료: $partnerUid");

        // 커플 연결 성공 → `HomeScreen`으로 이동 & `RequestScreen`/`ResponseScreen` 제거
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                (route) => false, // 모든 기존 화면 제거
          );
        }
      } else {
        print("❌ 초대 코드가 올바르지 않습니다.");
      }
    } catch (e) {
      print("🔥 오류 발생: $e");
    }
  }
}
