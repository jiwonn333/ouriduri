import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  bool _isLoaded = false; // 초기화 방지 test

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _loadEvents();  // 빌드 시마다 로드 (한 번만)
      _isLoaded = true;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 20),
          _buildEventButtons(),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Calendar'),
      titleTextStyle: const TextStyle(
          fontSize: 28, fontFamily: 'Ouriduri', color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _addEventDialog,
      elevation: 0,
      child: const Icon(Icons.edit),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_getDateOnly(_selectedDay!), _getDateOnly(day)),
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDate) => _focusedDay = _getDateOnly(focusedDate), // 날짜만 남기기
      calendarStyle: _calendarStyle(),
      headerStyle: _headerStyle(),

      // 특정 날짜 점 표시
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, event) {
          if (_events[_getDateOnly(day)] != null && _events[_getDateOnly(day)]!.isNotEmpty) {
            return Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pinkAccent,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = _getDateOnly(selectedDay);
      _focusedDay = _getDateOnly(focusedDay);
    });
  }

  CalendarStyle _calendarStyle() {
    return const CalendarStyle(
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
        color: Colors.black, // 클릭된 날짜 텍스트 색상
      ),
    );
  }

  HeaderStyle _headerStyle() {
    return HeaderStyle(
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
    );
  }

  // 이벤트 버튼을 생성하고, 선택된 날짜에만 표시
  Widget _buildEventButtons() {
    List<String> events = _events[_getDateOnly(_selectedDay!)] ?? []; // 날짜만 남기기
    return Column(
      children: events.map((event) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: OutlinedButton(
            onPressed: () {},
            onLongPress: () {
              _confirmDeleteEvent(event);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: const BorderSide(color: Colors.black45),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(
              event,
              style: TextStyle(color: Colors.black), // 글자색 검정으로 설정
            ),
          ),
        );
      }).toList(),
    );
  }

  // 이벤트 추가 다이얼로그
  void _addEventDialog() {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("이벤트 추가"),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: "이벤트 내용을 입력하세요"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                _saveEvent(eventController.text);
                Navigator.of(context).pop();
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }

  // 이벤트 저장 메서드
  void _saveEvent(String event) async {
    if (event.isNotEmpty && _selectedDay != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime dateOnly = _getDateOnly(_selectedDay!); // 시간이 제거된 날짜 사용
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);
      setState(() {
        if (_events[dateOnly] == null) {
          _events[dateOnly] = [];
        }
        _events[dateOnly]!.add(event);
      });
      // SharedPreferences에 저장
      prefs.setStringList(formattedDate, _events[dateOnly]!);
    }
  }

  // 저장된 이벤트 불러오기
  void _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<DateTime, List<String>> loadedEvents = {};
    for (var key in prefs.getKeys()) {
      if (_isValidDate(key)) {
        DateTime date = _getDateOnly(DateFormat('yyyy-MM-dd').parse(key));
        List<String> eventList = prefs.getStringList(key) ?? [];
        loadedEvents[date] = eventList;
      }
    }

    print('getkeys() and value : ${loadedEvents.keys} + ${loadedEvents.values}');

    setState(() {
      _events = loadedEvents;
    });
  }

  // 날짜 형식 'yyyy-MM-dd' 확인
  bool _isValidDate(String key) {
    try {
      DateFormat('yyyy-MM-dd').parse(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _confirmDeleteEvent(String event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("이벤트 삭제"),
        content: const Text("이벤트를 삭제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              _deleteEvent(event);
              Navigator.of(context).pop();
            },
            child: const Text("삭제"),
          ),
        ],
      ),
    );
  }

  // 이벤트 삭제 메서드
  void _deleteEvent(String event) async {
    setState(() {
      _events[_selectedDay]?.remove(event);
      if (_events[_selectedDay]?.isEmpty ?? true) {
        _events.remove(_selectedDay);
      }
      _saveEventsToPrefs();
    });
  }

  // SharedPreferences에 저장된 이벤트 업데이트
  void _saveEventsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_selectedDay != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);
      prefs.setStringList(formattedDate, _events[_selectedDay] ?? []);
    }
  }

  // 헬퍼 메서드: 날짜만 남기기 (시간 정보 제거)
  DateTime _getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
