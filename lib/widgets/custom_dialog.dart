import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String content;

  const CustomDialog(this.content, {super.key});

  static void show(BuildContext context, String message) {
    if (context.mounted) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CustomDialog(message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Center(child: Text(content)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "확인",
            style: TextStyle(
              color: AppColors.primaryDarkPink,
            ),
          ),
        ),
      ],
    );
  }
}
