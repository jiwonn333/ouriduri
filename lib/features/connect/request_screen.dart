import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:ouriduri_couple_app/features/connect/response_screen.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';

import '../../core/utils/app_colors.dart';
import '../../navigation/main_navigation_screen.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String _inviteCode = '';

  @override
  void initState() {
    super.initState();
    _inviteCode = _generateRandomCode();
    _saveInviteCodeToFirestore();
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          // ✅ 상대방이 초대 코드 입력 후 커플 연결 성공 시, 자동으로 `HomeScreen`으로 이동
          if (userData != null && userData["isConnected"] == true) {
            Future.microtask(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                    (route) => false, // 기존 화면 모두 제거
              );
            });
          }
        }

        return Scaffold(
          appBar: const CustomAppBar(title: '초대하기', bgColor: Colors.transparent),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "초대 코드: $_inviteCode",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _inviteCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("초대 코드가 복사되었습니다!")),
                        );
                      },
                      child: const Icon(
                        Icons.content_copy,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _shareToKakaoTalk, // ✅ 카카오톡 공유
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 46),
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: AppColors.primaryPink,
                  ),
                  child: const Text(
                    "초대 코드 공유",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const ResponseScreen(inviteCode: "")),
                    );
                  },
                  child: const Text(
                    "상대방의 초대 코드를 알고 계신가요?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent, // 링크처럼 보이게 설정
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ 초대 코드 랜덤 생성 (9자리)
  String _generateRandomCode({int length = 9}) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length,
              (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

  // ✅ Firestore에 초대 코드 저장
  Future<void> _saveInviteCodeToFirestore() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'inviteCode': _inviteCode, // ✅ 초대 코드 필드 추가
      });
    }
  }

  // ✅ 카카오톡 공유 기능
  Future<void> _shareToKakaoTalk() async {
    try {
      bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

      final template = TextTemplate(
        text: 'OuriDuri 초대 코드: $_inviteCode\n앱에서 연결을 진행해주세요!',
        link: Link(
          webUrl: Uri.parse('https://yourwebsite.com/invite?code=$_inviteCode'),
          // 웹 Fallback URL
          mobileWebUrl:
          Uri.parse('https://yourwebsite.com/invite?code=$_inviteCode'),
          androidExecutionParams: {'invite_code': _inviteCode},
          // Android 앱에서 실행할 딥링크
          iosExecutionParams: {'invite_code': _inviteCode}, // iOS 앱에서 실행할 딥링크
        ),
      );

      if (isKakaoTalkSharingAvailable) {
        final uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
      } else {
        final shareUrl =
        await WebSharerClient.instance.makeDefaultUrl(template: template);
        await launchBrowserTab(shareUrl, popupOpen: true);
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }
}
