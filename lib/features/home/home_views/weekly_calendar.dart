import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_colors.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 26),
            Text("${now.year}년 ",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("${now.month}월",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                Text(DateFormat('E', 'ko_KR').format(date),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

