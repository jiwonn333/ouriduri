import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(color: AppColors.dividerLineColor, width: 1)),
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,

        /// 아이콘 선택시 밀림 방지
        selectedItemColor: AppColors.primaryPink,
        unselectedItemColor: Colors.black54,
        onTap: onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
