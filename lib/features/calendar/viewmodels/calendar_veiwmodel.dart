import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/couple_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel() {
    loadEvents();
  }

  /* 상태 */
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<String>> events = {};

  final _prefsFuture = SharedPreferences.getInstance();
  final _coupleService = CoupleService();

  /* 날짜 클릭 */
  void onDaySelected(DateTime sel, DateTime foc) {
    selectedDay = _date(sel);
    focusedDay  = _date(foc);
    notifyListeners();
  }

  void onFormatChanged(CalendarFormat f) {
    if (calendarFormat != f) {
      calendarFormat = f;
      notifyListeners();
    }
  }

  void onPageChanged(DateTime d) => focusedDay = _date(d);

  /* ───── CRUD ───── */

  Future<void> addEvent(
      String memo, DateTime start, DateTime end, bool allDay) async {
    if (memo.trim().isEmpty) return;
    final prefs = await _prefsFuture;
    final id = await _coupleService.getCurrentCoupleId();
    if (id == null) return;

    final dateKey = _date(start);
    final spKey   = '$id-${_fmt(dateKey)}';

    events.putIfAbsent(dateKey, () => []).add(memo);
    await prefs.setStringList(spKey, events[dateKey]!);
    notifyListeners();
  }

  Future<void> deleteEvent(String memo) async {
    final prefs = await _prefsFuture;
    final id = await _coupleService.getCurrentCoupleId();
    if (id == null) return;

    final dateKey = _date(selectedDay);
    final spKey   = '$id-${_fmt(dateKey)}';

    events[dateKey]?.remove(memo);
    if (events[dateKey]?.isEmpty ?? true) {
      events.remove(dateKey);
      await prefs.remove(spKey);
    } else {
      await prefs.setStringList(spKey, events[dateKey]!);
    }
    notifyListeners();
  }

  Future<void> loadEvents() async {
    final prefs = await _prefsFuture;
    final id = await _coupleService.getCurrentCoupleId();
    if (id == null) return;

    final map = <DateTime, List<String>>{};
    for (final k in prefs.getKeys()) {
      final parts = k.split('-');
      if (parts.length == 2 && parts.first == id && _isDate(parts.last)) {
        map[_parse(parts.last)] = prefs.getStringList(k) ?? [];
      }
    }
    events = map;
    notifyListeners();
  }

  /* ─ helpers ─ */
  DateTime _date(DateTime d) => DateTime(d.year, d.month, d.day);
  String _fmt(DateTime d)   => DateFormat('yyyy/MM/dd').format(d);
  DateTime _parse(String s) => _date(DateFormat('yyyy/MM/dd').parse(s));
  bool _isDate(String s) {
    try { DateFormat('yyyy/MM/dd').parseStrict(s); return true; } catch (_) { return false; }
  }
}