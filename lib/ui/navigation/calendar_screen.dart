import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ouriduri_couple_app/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Calendar", bgColor: Colors.transparent),
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
      selectedDayPredicate: (day) =>
          isSameDay(_getDateOnly(_selectedDay!), _getDateOnly(day)),
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDate) => _focusedDay = _getDateOnly(focusedDate),
      // 날짜만 남기기
      calendarStyle: _calendarStyle(),
      headerStyle: _headerStyle(),

      // 특정 날짜 점 표시
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, event) {
          if (_events[_getDateOnly(day)] != null &&
              _events[_getDateOnly(day)]!.isNotEmpty) {
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

    // 이벤트가 있는 경우에만 이벤트 버튼 표시
    if (events.isEmpty) {
      return Container(); // 이벤트가 없으면 빈 컨테이너 반환
    }

    // 이벤트 버튼을 보여주는데, 이벤트가 많을 경우 스크롤 가능하게 처리
    return Column(
      children: [
        if (events.length > 3)
          // 이벤트가 4개 이상일 경우 스크롤 가능하도록 ListView 사용
          Container(
            height: 300, // 고정 높이를 지정하여 스크롤 영역을 만듦
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                String event = events[index];
                return _buildEventButton(event);
              },
            ),
          )
        else
          // 이벤트가 3개 이하일 경우 그냥 Column으로 표시
          Column(
            children: events.map((event) => _buildEventButton(event)).toList(),
          ),
      ],
    );
  }

  // 이벤트 버튼을 생성하고, 선택된 날짜에만 표시
  Widget _buildEventButton(String event) {
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
      String? uid = await _getUserUID();
      if (uid != null) {
        DateTime dateOnly = _getDateOnly(_selectedDay!);
        String userSpecificKey =
            '$uid-${DateFormat('yyyy/MM/dd').format(_selectedDay!)}';

        setState(() {
          _events.putIfAbsent(dateOnly, () => []).add(event);
        });
        // SharedPreferences에 저장
        prefs.setStringList(userSpecificKey, _events[dateOnly]!);
      }
    }
  }

  // 저장된 이벤트 불러오기
  void _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = await _getUserUID();
    print('get uid : $uid');
    if (uid != null) {
      Map<DateTime, List<String>> loadedEvents = {};
      for (var key in prefs.getKeys()) {
        var parts = key.split('-');

        if (parts.length > 1 &&
            parts.first == uid &&
            _isValidDate(parts.last)) {
          // 날짜 부분 추출
          DateTime date =
              _getDateOnly(DateFormat('yyyy/MM/dd').parse(parts.last));
          List<String> eventList = prefs.getStringList(key) ?? [];
          loadedEvents[date] = eventList;
        }
      }

      setState(() {
        _events = loadedEvents;
      });
    }
  }

  // 날짜 형식 'yyyy-MM-dd' 확인
  bool _isValidDate(String date) {
    try {
      DateFormat('yyyy/MM/dd').parse(date);
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
    if (_selectedDay != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = await _getUserUID();
      if (uid != null) {
        DateTime dateOnly = _getDateOnly(_selectedDay!);
        String formattedDate = DateFormat('yyyy/MM/dd').format(dateOnly!);
        String userSpecificKey = '$uid-$formattedDate';
        setState(() {
          _events[dateOnly]?.remove(event); // 해당 날짜에서 이벤트(리스트) 삭제
          if (_events[dateOnly]?.isEmpty ?? true) {
            // 이벤트가 비어있으면 해당 날짜를 _events에서 삭제
            _events.remove(dateOnly);
            // 이벤트가 빈 리스트 (즉, 없으면) SharedPreferences 에서 해당 날짜 데이터 삭제(키 삭제)
            prefs.remove(userSpecificKey);
          } else {
            // 이벤트가 남아있으면 업데이트 된 리스트 저장
            prefs.setStringList(userSpecificKey, _events[dateOnly]!);
          }
        });
      }
    }
  }

  // 헬퍼 메서드: 날짜만 남기기 (시간 정보 제거)
  DateTime _getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<String?> _getUserUID() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user?.uid;
  }
}
