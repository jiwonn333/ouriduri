import 'package:flutter/material.dart';

class StartFooter extends StatelessWidget {
  const StartFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '@ouriduri',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
