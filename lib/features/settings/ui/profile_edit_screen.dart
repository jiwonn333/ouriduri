import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = "남성"; // 기본 성별

  // 생년월일 선택
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1), // 기본 날짜
      firstDate: DateTime(1900), // 최소 선택 가능 연도
      lastDate: DateTime.now(), // 현재 날짜까지 가능
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // 저장 버튼 클릭 시
  void _saveProfile() {
    print("닉네임: ${_nicknameController.text}");
    print("생년월일: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : '선택 안됨'}");
    print("성별: $_selectedGender");

    Navigator.pop(context); // 저장 후 뒤로 가기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("프로필 편집")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닉네임 입력
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: "닉네임"),
            ),
            SizedBox(height: 16),

            // 생년월일 선택
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "생년월일",
                    hintText: _selectedDate != null
                        ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
                        : "생년월일 선택",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // 성별 선택
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ["남성", "여성", "기타"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              decoration: InputDecoration(labelText: "성별"),
            ),
            SizedBox(height: 24),

            // 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: Text("저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
