import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/terms_bottom_sheet_state.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_colors.dart';
import '../sign_in_screen.dart';
import '../../view/terms_bottom_sheet.dart';

class StartButtons extends StatelessWidget {
  const StartButtons({super.key});

  void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => ChangeNotifierProvider(
        create: (_) => TermsBottomSheetState(),
        child: const TermsBottomSheet(),
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => const SignInScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildElevatedButton(
          label: "시작",
          onPressed: () => _showTermsBottomSheet(context),
          backgroundColor: Colors.white,
          borderColor: AppColors.primaryPink,
          textColor: AppColors.primaryDarkPink,
        ),
        const SizedBox(height: 10),
        _buildElevatedButton(
          label: "로그인",
          onPressed: () => _showLoginBottomSheet(context),
          backgroundColor: AppColors.primaryPink,
          borderColor: Colors.transparent,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(230, 46),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
