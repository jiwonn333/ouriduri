import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/join_bottom_sheeet.dart';
import 'package:ouriduri_couple_app/webview_page.dart';

import 'app_colors.dart';

class TermsAgreementBottomSheet extends StatefulWidget {
  @override
  _TermsAgreementBottomSheetState createState() =>
      _TermsAgreementBottomSheetState();
}

class _TermsAgreementBottomSheetState extends State<TermsAgreementBottomSheet> {
  bool allChecked = false;
  bool termsChecked = false;
  bool privacyChecked = false;

  void _updateAllChecked(bool? value) {
    setState(() {
      allChecked = value ?? false;
      termsChecked = allChecked;
      privacyChecked = allChecked;
    });
  }

  void _updateIndividualCheck(bool? value, String type) {
    setState(() {
      if (type == 'terms') {
        termsChecked = value ?? false;
      } else if (type == 'privacy') {
        privacyChecked = value ?? false;
      }
      allChecked = termsChecked && privacyChecked;
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
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '[필수] ',
                style: const TextStyle(
                  color: AppColors.primaryDarkPink,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ouriduri',
                ),
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
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
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text(
              '이용약관에 동의해 주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: allChecked,
              onChanged: _updateAllChecked,
              activeColor: AppColors.primaryDarkPink,
              title: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "모두 동의합니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ouriduri',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
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
            ElevatedButton(
              onPressed: allChecked
                  ? () {
                      Navigator.pop(context); // 현재 BottomSheet를 닫음
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          builder: (context) => JoinBottomSheet());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(360, 50), // 버튼의 최소 크기 설정 (너비 x 높이)
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0), // 버튼 내부 여백 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
                ),
                backgroundColor: AppColors.primaryPink,
              ),
              child: const Text(
                '동의하고 계속하기',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
