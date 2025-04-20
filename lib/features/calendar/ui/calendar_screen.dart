import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/features/calendar/screen_views/event_list.dart';
import 'package:ouriduri_couple_app/features/calendar/screen_views/monthly_calendar.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/calendar_veiwmodel.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();
    debugPrintAllPrefs();
    return Scaffold(
      appBar:
          const CustomAppBar(title: "Calendar", bgColor: Colors.transparent),
      body: Column(
        children: [
          MonthlyCalendar(
              focusedDay: viewModel.focusedDay,
              selectedDay: viewModel.selectedDay,
              calendarFormat: viewModel.calendarFormat,
              events: viewModel.events,
              onDaySelected: viewModel.onDaySelected,
              onFormatChanged: viewModel.onFormatChanged,
              onPageChanged: viewModel.onPageChanged),
          const SizedBox(height: 20),
          EventList(
            events: viewModel.events[viewModel.selectedDay] ?? [],
            onLongPress: (event) =>
                viewModel.confirmDeleteEvent(context, event),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () => viewModel.addEventDialog(context)),
    );
  }
  void debugPrintAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (final key in allKeys) {
      final value = prefs.get(key); // key에 해당하는 값을 가져옴
      print('[$key] = $value');
    }
  }
}
