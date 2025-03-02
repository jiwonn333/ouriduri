import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/signup_screen.dart';
import 'package:ouriduri_couple_app/features/webview/webview_page.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';

import '../../../core/utils/app_colors.dart';

class TermsBottomSheet extends StatefulWidget {
  const TermsBottomSheet({super.key});

  @override
  _TermsBottomSheetState createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<TermsBottomSheet> {
  bool allChecked = false;
  bool isAgeOver14 = false;
  bool termsChecked = false;
  bool privacyChecked = false;

  void _updateAllChecked(bool? value) {
    setState(() {
      allChecked = value ?? false;
      isAgeOver14 = allChecked;
      termsChecked = allChecked;
      privacyChecked = allChecked;
    });
  }

  void _updateIndividualCheck(bool? value, String type) {
    setState(() {
      if (type == 'age') {
        isAgeOver14 = value ?? false;
      } else if (type == 'terms') {
        termsChecked = value ?? false;
      } else if (type == 'privacy') {
        privacyChecked = value ?? false;
      }
      allChecked = isAgeOver14 && termsChecked && privacyChecked;
    });
  }

  Widget _buildCheckBoxTile({
    required bool value,
    required String label,
    required VoidCallback? onTap,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryDarkPink,
      side: const BorderSide(color: Colors.grey, width: 2),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '[필수] ',
                style: const TextStyle(
                  color: AppColors.primaryDarkPink,
                  fontSize: 16,
                  fontFamily: 'Ouriduri',
                ),
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Ouriduri',
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.open_in_new_rounded,
                size: 18.0,
                color: Colors.black45,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30.0),
                Text(
                  '우리두리를 이용하려면 약관 동의가 필요해요',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: allChecked,
              onChanged: _updateAllChecked,
              activeColor: AppColors.primaryDarkPink,
              side: const BorderSide(color: Colors.grey, width: 2),
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              title: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "모두 동의합니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ouriduri',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 1,
            ),
            CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: isAgeOver14,
                activeColor: AppColors.primaryDarkPink,
                side: const BorderSide(color: Colors.grey, width: 2),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                title: const Text.rich(
                  TextSpan(
                    text: '[필수] ',
                    style: TextStyle(
                      color: AppColors.primaryDarkPink,
                      fontSize: 16,
                      fontFamily: 'Ouriduri',
                    ),
                    children: [
                      TextSpan(
                        text: "만 14세 이상입니다.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Ouriduri',
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (value) => _updateIndividualCheck(value, 'age')),
            _buildCheckBoxTile(
              value: termsChecked,
              label: '이용약관 동의',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      appBarTitle: "이용약관",
                      url:
                          "https://ajar-vise-a12.notion.site/14157d0601f7807ba2c0eda287fbcdd2?pvs=4",
                    ),
                  ),
                );
              },
              onChanged: (value) => _updateIndividualCheck(value, 'terms'),
            ),
            _buildCheckBoxTile(
              value: privacyChecked,
              label: '개인정보 처리방침 동의',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      appBarTitle: "개인정보 처리방침",
                      url:
                          "https://ajar-vise-a12.notion.site/14757d0601f7809494fefe57fb3adbdd?pvs=4",
                    ),
                  ),
                );
              },
              onChanged: (value) => _updateIndividualCheck(value, 'privacy'),
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              isValidated: allChecked,
              onPressed: () {
                Navigator.pop(context); // 현재 BottomSheet를 닫음
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              btnText: "동의하고 계속하기",
            ),
          ],
        ),
      ),
    );
  }
}
