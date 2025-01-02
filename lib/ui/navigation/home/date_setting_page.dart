import 'package:flutter/cupertino.dart';
import 'package:ouriduri_couple_app/ui/navigation/home/date_setting_viewmodel.dart';
import 'package:provider/provider.dart';

import 'date_setting_screen.dart';

class DateSettingPage extends StatelessWidget {
  const DateSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DateSettingViewModel(),
        child: const DateSettingScreen());
  }
}
