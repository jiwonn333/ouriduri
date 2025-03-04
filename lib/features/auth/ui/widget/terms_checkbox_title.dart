import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class TermsCheckboxTitle extends StatelessWidget {
  final bool value;
  final String label;
  final VoidCallback? onTap;
  final ValueChanged<bool?> onChanged;

  const TermsCheckboxTitle(
      {super.key,
      required this.value,
      required this.label,
      this.onTap,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isAllAgree = label == "모두 동의합니다.";
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
                text: isAllAgree ? '' : '[필수] ',
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
}
