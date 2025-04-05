import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/signup_screen.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/terms_bottom_sheet_state.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/terms_checkbox_title.dart';
import 'package:ouriduri_couple_app/features/webview/webview_page.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';

class TermsBottomSheet extends StatelessWidget {
  const TermsBottomSheet({super.key});

  void _navigateToWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(appBarTitle: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TermsBottomSheetState>();
    final double screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => TermsBottomSheetState(),
      child: FractionallySizedBox(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TermsCheckboxTitle(
                    value: state.allChecked,
                    label: "모두 동의합니다.",
                    onChanged: state.updateAllChecked,
                  ),
                  const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                  TermsCheckboxTitle(
                    value: state.isAgeOver14,
                    label: "만 14세 이상입니다.",
                    onChanged: (value) =>
                        state.updateIndividualCheck(value, 'age'),
                  ),
                  TermsCheckboxTitle(
                    value: state.termsChecked,
                    label: "이용약관 동의",
                    onTap: () => _navigateToWebView(
                      context,
                      "이용약관",
                      "https://ajar-vise-a12.notion.site/14157d0601f7807ba2c0eda287fbcdd2?pvs=4",
                    ),
                    onChanged: (value) =>
                        state.updateIndividualCheck(value, 'terms'),
                  ),
                  TermsCheckboxTitle(
                    value: state.privacyChecked,
                    label: "개인정보 처리방침 동의",
                    onTap: () => _navigateToWebView(
                      context,
                      "개인정보 처리방침",
                      "https://ajar-vise-a12.notion.site/14757d0601f7809494fefe57fb3adbdd?pvs=4",
                    ),
                    onChanged: (value) =>
                        state.updateIndividualCheck(value, 'privacy'),
                  ),
                  const SizedBox(height: 10.0),
                  CustomElevatedButton(
                      isValidated: state.allChecked,
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
      ),
    );
  }
}
