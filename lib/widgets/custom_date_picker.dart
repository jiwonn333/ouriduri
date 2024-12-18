import 'package:flutter/cupertino.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateTimeChanged;

  const CustomDatePicker({
    super.key,
    required this.onDateTimeChanged,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        initialDateTime: selectedDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: onDateTimeChanged,
        minimumDate: DateTime(1900),
        maximumDate: DateTime.now(),
        dateOrder: DatePickerDateOrder.ymd,
      ),
    );
  }
}
