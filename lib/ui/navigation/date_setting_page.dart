import 'package:flutter/cupertino.dart';
import 'package:ouriduri_couple_app/ui/navigation/date_setting_screen.dart';
import 'package:ouriduri_couple_app/ui/navigation/date_setting_viewmodel.dart';
import 'package:provider/provider.dart';

class DateSettingPage extends StatelessWidget {
  const DateSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DateSettingViewModel(),
        child: const DateSettingScreen());
  }
}
