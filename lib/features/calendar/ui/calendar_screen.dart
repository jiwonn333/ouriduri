import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_app_bar.dart';
import '../screen_views/bottom_sheet/calendar_event_bottom_sheet.dart';
import '../screen_views/event_list.dart';
import '../screen_views/monthly_calendar.dart';
import '../viewmodels/calendar_veiwmodel.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();

    return Scaffold(
      appBar:
          const CustomAppBar(title: 'Calendar', bgColor: Colors.transparent),
      body: Column(
        children: [
          MonthlyCalendar(
            focusedDay: viewModel.focusedDay,
            selectedDay: viewModel.selectedDay,
            calendarFormat: viewModel.calendarFormat,
            events: viewModel.events,
            onDaySelected: viewModel.onDaySelected,
            onFormatChanged: viewModel.onFormatChanged,
            onPageChanged: viewModel.onPageChanged,
          ),
          const SizedBox(height: 20),
          EventList(
            events: viewModel.events[viewModel.selectedDay] ?? [],
            onLongPress: viewModel.deleteEvent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showCupertinoModalPopup(
          context: context,
          barrierColor: Colors.black.withOpacity(0.3),
          builder: (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: CalendarEventBottomSheet(
              initialDate: viewModel.selectedDay,
              onSave: viewModel.addEvent,
            ),
          ),
        ),
      ),
    );
  }
}
