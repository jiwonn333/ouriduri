import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String content;

  const CustomDialog(this.content, {super.key});

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
                  fontFamily: 'San Francisco font'),
            ))
      ],
    );
  }
}
