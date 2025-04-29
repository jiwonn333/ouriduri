import 'package:flutter/cupertino.dart';

import '../../../../core/utils/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.onClose, required this.onSave});
  final VoidCallback onClose;
  final VoidCallback onSave;
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onClose,
        child: const Icon(CupertinoIcons.xmark, size: 24, color: CupertinoColors.inactiveGray,),
      ),
      CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        color: AppColors.primaryPink,
        borderRadius: BorderRadius.circular(22),
        onPressed: onSave,
        child: const Text('저장',
            style: TextStyle(color: CupertinoColors.white)),
      ),
    ],
  );
}