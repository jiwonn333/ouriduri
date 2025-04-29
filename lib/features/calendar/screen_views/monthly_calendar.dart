import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils/app_colors.dart';

class MonthlyCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final void Function(DateTime) onPageChanged;

  const MonthlyCalendar(
      {super.key,
      required this.focusedDay,
      required this.selectedDay,
      required this.calendarFormat,
      required this.events,
      required this.onDaySelected,
      required this.onFormatChanged,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 1, 1),
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      selectedDayPredicate: (day) => isSameDay(
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day), day),
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
      onPageChanged: onPageChanged,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
        todayTextStyle: TextStyle(
          color: AppColors.primaryPink,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.primaryLightPink,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: AppColors.primaryDarkPink, // 클릭된 날짜 텍스트 색상
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextFormatter: (date, locale) =>
            DateFormat.MMMM(locale).format(date),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final hasEvent =
              this.events[DateTime(day.year, day.month, day.day)]?.isNotEmpty ??
                  false;
          if (hasEvent) {
            return Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLightPink,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
