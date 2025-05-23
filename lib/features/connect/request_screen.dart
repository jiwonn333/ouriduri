import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/features/connect/request_view_model.dart';
import 'package:ouriduri_couple_app/features/connect/response_screen.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';

import '../../core/utils/app_colors.dart';
import '../../navigation/main_navigation_screen.dart';

class RequestScreen extends ConsumerWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestViewModelProvider);
    final viewModel = ref.read(requestViewModelProvider.notifier);

    if (state.isConnected) {
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()),
            (route) => false);
      });
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
                  "초대코드 : ${state.inviteCode}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: state.inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("초대 코드가 복사되었습니다!")),
                    );
                  },
                  child: const Icon(Icons.content_copy,
                      color: Colors.grey, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isLoading ? null : viewModel.shareToKakao,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 46),
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                backgroundColor: AppColors.primaryPink,
              ),
              child: state.isLoading
                  ? null
                  : const Text(
                      "초대 코드 공유",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                  color: Colors.blueAccent,
                ),
              ),
            ),
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
