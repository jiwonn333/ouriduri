import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
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
    initDeepLinkListener();
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
            onPressed: () {
              _shareToKakaoTalk();
            },
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

  // 카카오톡 공유
  Future<void> _shareToKakaoTalk() async {
    try {
      bool isKakaoTalkSharingAvailable =
          await ShareClient.instance.isKakaoTalkSharingAvailable();
      // User user = await UserApi.instance.me();
      // final name = user.kakaoAccount?.profile?.nickname;

      final template = _createTextTemplate('test');

      if (isKakaoTalkSharingAvailable) {
        final uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } else {
        final shareUrl =
            await WebSharerClient.instance.makeDefaultUrl(template: template);
        await launchBrowserTab(shareUrl, popupOpen: true);
        print('카카오톡 설치되지 않음, 웹 공유');
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }

  // 공유 템플릿 생성
  TextTemplate _createTextTemplate(String inviterName) {
    String inviteLink =
        'superouriduri://ouriduri/connect_screen?invite_code=$_inviteCode';
    String fallbackUrl =
        'https://ouriduri.com/connect_screen?invite_code=$_inviteCode';

    return TextTemplate(
      text: '$inviterName 님이 당신을 초대했어요!\n앱에서 연결을 진행해주세요.',
      link: Link(
        webUrl: Uri.parse(fallbackUrl),
        // 앱이 없으면 웹으로 이동
        mobileWebUrl: Uri.parse(fallbackUrl),
        androidExecutionParams: {'invite_code': _inviteCode},
        // Android 앱에서 실행할 딥링크
        iosExecutionParams: {'invite_code': _inviteCode}, // iOS 앱에서 실행할 딥링크
      ),
    );
  }

  // 딥링크 감지
  void initDeepLinkListener() {
    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((Uri? uri) {
      print("🔍 딥링크 감지됨: $uri"); // 로그 확인

      if (uri != null && uri.path == '/connect_page') {
        final inviteCode = uri.queryParameters['invite_code'];
        print("📌 초대 코드: $inviteCode"); // 초대 코드 값 확인

        Navigator.pushNamed(context, '/connect_page', arguments: inviteCode);
      }
    });
  }
}
