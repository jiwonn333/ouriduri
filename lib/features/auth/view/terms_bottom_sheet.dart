import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/terms/terms_view_model.dart';

import '../../../widgets/custom_elevated_button.dart';
import '../../webview/webview_page.dart';
import '../ui/signup_screen.dart';
import '../ui/widget/terms_checkbox_title.dart';

class TermsBottomSheet extends ConsumerWidget {
  const TermsBottomSheet({super.key});

  void _navigateToWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(appBarTitle: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsState = ref.watch(termsViewModelProvider);
    final termsViewModel = ref.read(termsViewModelProvider.notifier);
    final double screenHeight = MediaQuery.of(context).size.height;

    return FractionallySizedBox(
      heightFactor: screenHeight <= 667 ? 0.5 : 0.4,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 32.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    '우리두리를 이용하려면 약관 동의가 필요해요',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5.0),
                TermsCheckboxTitle(
                  value: termsState.isAllAgreed,
                  label: "모두 동의합니다.",
                  onChanged: (value) {
                    if (value != null) {
                      termsViewModel.toggleAllAgreed(value);
                    }
                  },
                ),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                TermsCheckboxTitle(
                  value: termsState.isAgeOver14,
                  label: "만 14세 이상입니다.",
                  onChanged: (value) {
                    if (value != null) {
                      termsViewModel.toggleAgeOver14(value);
                    }
                  },
                ),
                TermsCheckboxTitle(
                  value: termsState.isServiceAgreed,
                  label: "이용약관 동의",
                  onTap: () => _navigateToWebView(
                    context,
                    "이용약관",
                    "https://ajar-vise-a12.notion.site/14157d0601f7807ba2c0eda287fbcdd2?pvs=4",
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      termsViewModel.toggleServiceAgreed(value);
                    }
                  },
                ),
                TermsCheckboxTitle(
                  value: termsState.isPrivacyAgreed,
                  label: "개인정보 처리방침 동의",
                  onTap: () => _navigateToWebView(
                    context,
                    "개인정보 처리방침",
                    "https://ajar-vise-a12.notion.site/14757d0601f7809494fefe57fb3adbdd?pvs=4",
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      termsViewModel.togglePrivacyAgreed(value);
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                CustomElevatedButton(
                    isValidated: termsState.isAllAgreed,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    btnText: "동의하고 계속하기")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
