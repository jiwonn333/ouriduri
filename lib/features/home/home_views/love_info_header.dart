import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';
import 'package:ouriduri_couple_app/features/home/viewmodels/home_base_viewmodel.dart';

import '../ui/date_setting_page.dart';

class LoveInfoHeader extends StatelessWidget {
  const LoveInfoHeader({Key? key, required this.viewModel}) : super(key: key);

  final HomeBaseViewModel viewModel;

  int calculateLoveDays(DateTime startDate) {
    return DateTime.now().difference(startDate).inDays + 1;
  }

  int getLoveLevel(int loveDays) {
    if (loveDays < 30) return 1;
    if (loveDays < 100) return 2;
    if (loveDays < 200) return 3;
    if (loveDays < 365) return 4;
    if (loveDays < 500) return 5;
    if (loveDays < 700) return 6;
    if (loveDays < 900) return 7;
    if (loveDays < 1100) return 8;
    if (loveDays < 1300) return 9;
    return 10;
  }

  String getLevelTitle(int level) {
    switch (level) {
      case 1:
        return "썸의 시작";
      case 2:
        return "초보 연인";
      case 3:
        return "달콤한 커플";
      case 4:
        return "1년의 벽 돌파";
      case 5:
        return "단단한 우리";
      case 6:
        return "장기 연애 모드";
      case 7:
        return "찰떡 케미 커플";
      case 8:
        return "추억 부자";
      case 9:
        return "영혼의 단짝";
      case 10:
        return "오래된 연인";
      default:
        return "사랑이 시작됐어요";
    }
  }

  @override
  Widget build(BuildContext context) {
    int loveDays = viewModel.startDate != null
        ? calculateLoveDays(viewModel.startDate!)
        : 0;
    int level = getLoveLevel(loveDays);
    String levelTitle = getLevelTitle(level);

    return SizedBox(
      height: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20), // 👈 앞에 여백 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lv.$level  $levelTitle",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryDarkPink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('사랑한 지  ', style: TextStyle(fontSize: 18)),
                      Text('$loveDays',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text(' 일 째', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(viewModel.userName ?? '사용자',
                          style: const TextStyle(fontSize: 18)),
                      const Icon(Icons.favorite,
                          color: AppColors.primaryPink, size: 16),
                      Text(viewModel.partnerName ?? '파트너',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final selectedDate = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DateSettingPage()),
              );
              if (selectedDate != null) {
                viewModel.saveStartDate(selectedDate);
              }
            },
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ],
      ),
    );
  }
}
