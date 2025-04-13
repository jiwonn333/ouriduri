import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';
import 'package:ouriduri_couple_app/features/home/viewmodels/home_base_viewmodel.dart';
import 'package:provider/provider.dart';

import 'date_setting_page.dart';

class HomeBaseScreen extends StatelessWidget {
  const HomeBaseScreen({super.key});

  int calculateLoveDays(DateTime startDate) {
    return DateTime.now().difference(startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeBaseViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, viewModel),
            _buildCalendarList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeBaseViewModel viewModel) {
    int loveDays = viewModel.startDate != null
        ? calculateLoveDays(viewModel.startDate!)
        : 0;

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              icon: const Icon(Icons.keyboard_arrow_right_rounded)),
        ],
      ),
    );
  }

  Widget _buildCalendarList() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday -1));
    List<DateTime> weekDates =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 26),
            Text("${now.year}년 ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("${now.month}월",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(color: Colors.grey, thickness: 0.4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDates.map((date) {
            bool isToday = now.day == date.day && now.month == date.month;
            return Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primaryPink.withOpacity(0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('d').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isToday ? AppColors.primaryPink : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('E', 'ko_KR').format(date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
