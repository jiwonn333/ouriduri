import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';
import 'package:ouriduri_couple_app/features/home/viewmodels/home_base_viewmodel.dart';
import 'package:provider/provider.dart';

import '../home_views/love_info_header.dart';
import '../home_views/weekly_calendar.dart';
import '../ui/date_setting_page.dart';

class HomeBaseScreen extends StatelessWidget {
  const HomeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeBaseViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            LoveInfoHeader(viewModel: viewModel), // 위젯 분리 후 호출
            const WeeklyCalendar(), // 위젯 분리 후 호출
          ],
        ),
      ),
    );
  }
}