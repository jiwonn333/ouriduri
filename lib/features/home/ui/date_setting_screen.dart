import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/utils/app_colors.dart';
import 'package:ouriduri_couple_app/features/home/viewmodels/date_setting_viewmodel.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';
import 'package:ouriduri_couple_app/widgets/custom_date_picker.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';

class DateSettingScreen extends StatefulWidget {
  const DateSettingScreen({super.key});

  @override
  State<DateSettingScreen> createState() => _DateSettingScreenState();
}

class _DateSettingScreenState extends State<DateSettingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DateSettingViewModel>().loadSelectedDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DateSettingViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "OuriDuri", bgColor: Colors.white),
      body: viewModel.isLoading // 로딩 상태 확인
          ? const Center(child: CircularProgressIndicator()) // 로딩 인디케이터 표시
          : Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      '우리의 기념일',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      viewModel.getFormattedDate(),
                      style: const TextStyle(
                          fontSize: 26,
                          color: AppColors.primaryDarkPink,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    CustomDatePicker(
                      selectedDate: viewModel.selectedDate,
                      onDateTimeChanged: (newDate) {
                        setState(() {
                          viewModel.updateSelectedDate(newDate);
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    CustomElevatedButton(
                      isValidated: true,
                      onPressed: () {
                        viewModel.saveSelectedDate();
                        Navigator.pop(context, viewModel.selectedDate);
                      },
                      btnText: "확인",
                    ),
                    // _buildConfirmButton(),
                  ],
                ),
              ),
            ),
    );
  }
}
