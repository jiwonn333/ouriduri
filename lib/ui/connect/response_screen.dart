import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class ResponseScreen extends StatefulWidget {
  final String? inviteCode;

  const ResponseScreen({Key? key, required this.inviteCode}) : super(key: key);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late TextEditingController _inviteCodeController;

  @override
  void initState() {
    super.initState();
    // 초대 코드 입력 컨트롤러 초기화 (딥링크 초대 코드가 있다면 기본값 설정)
    _inviteCodeController = TextEditingController(text: widget.inviteCode ?? "");
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "초대 코드 입력", bgColor: Colors.transparent),
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
                String enteredCode = _inviteCodeController.text.trim();
                if (enteredCode.isNotEmpty) {
                  print("✅ 입력된 초대 코드: $enteredCode");
                  // TODO: 입력된 초대 코드 처리 로직 추가
                } else {
                  print("❗초대 코드를 입력하세요.");
                }
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
}
