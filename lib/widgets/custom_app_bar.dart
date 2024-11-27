import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color bgColor;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: bgColor,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
