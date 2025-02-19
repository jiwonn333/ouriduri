import 'package:flutter/material.dart';

class CustomHandleBar extends StatelessWidget {
  const CustomHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.0,
      width: 50.0,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }
}
