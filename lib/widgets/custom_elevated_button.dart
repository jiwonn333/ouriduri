import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final String btnText;
  final bool isValidated;

  const CustomElevatedButton({
    super.key,
    required this.isValidated,
    required this.onPressed,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isValidated ? onPressed : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(360, 46),
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
        ),
        backgroundColor: isValidated ? AppColors.primaryPink : Colors.grey,
      ),
      child: Text(
        btnText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
