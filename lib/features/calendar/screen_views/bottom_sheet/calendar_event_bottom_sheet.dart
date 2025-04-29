import 'package:flutter/cupertino.dart';

import 'all_day_toggle.dart';
import 'date_row.dart';
import 'header.dart';
import 'memo_field.dart';

class CalendarEventBottomSheet extends StatefulWidget {
  const CalendarEventBottomSheet({
    super.key,
    required this.onSave,
    required this.initialDate,
  });

  final void Function(String memo, DateTime start, DateTime end, bool allDay)
      onSave;
  final DateTime initialDate;

  @override
  State<CalendarEventBottomSheet> createState() =>
      _CalendarEventBottomSheetState();
}

class _CalendarEventBottomSheetState extends State<CalendarEventBottomSheet> {
  final _memoCtrl = TextEditingController();
  bool _allDay = false;
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialDate;
    _end = _start.add(const Duration(hours: 1));
  }

  bool get _invalid => _start.isAfter(_end);

  /* 날짜/시간 선택 */
  Future<void> _pickDate({required bool isStart}) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          mode: _allDay
              ? CupertinoDatePickerMode.date
              : CupertinoDatePickerMode.dateAndTime,
          initialDateTime: isStart ? _start : _end,
          onDateTimeChanged: (d) => setState(() {
            if (isStart) {
              _start = d;
              if (_start.isAfter(_end))
                _end = _start.add(const Duration(hours: 1));
            } else {
              _end = d;
            }
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(
                  onClose: () => Navigator.pop(context),
                  onSave: () {
                    if (_invalid) return;
                    widget.onSave(
                      _memoCtrl.text.trim(),
                      _start,
                      _end,
                      _allDay,
                    );
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                MemoField(controller: _memoCtrl),
                const SizedBox(height: 20),
                AllDayToggle(
                  value: _allDay,
                  onChanged: (v) => setState(() => _allDay = v),
                ),
                const SizedBox(height: 16),
                DateRow(
                  label: '시작',
                  date: _start,
                  error: _invalid,
                  allDay: _allDay,
                  onTap: () => _pickDate(isStart: true),
                ),
                DateRow(
                  label: '종료',
                  date: _end,
                  error: _invalid,
                  allDay: _allDay,
                  onTap: () => _pickDate(isStart: false),
                ),
                if (_invalid)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('시작 시간이 종료보다 늦습니다.',
                        style: TextStyle(color: CupertinoColors.systemRed)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
