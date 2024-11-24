import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/validate.dart';

import 'app_colors.dart';

class JoinBottomSheet extends StatefulWidget {
  const JoinBottomSheet({super.key});

  @override
  State<JoinBottomSheet> createState() => _JoinBottomSheetState();
}

class _JoinBottomSheetState extends State<JoinBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // 실시간 에러 메시지 저장
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmError;
  String? _idError;

  bool _isFormValid = false;

  // 텍스트 입력 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  // Firebase Auth, Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 생년월일 기본 값 설정
  DateTime? _selectedDate = DateTime(2000, 1, 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: _buildForm(),
                ),
                // 닫기 버튼
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      Navigator.pop(context); // Bottom Sheet 닫기
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24.0),
          // 회원가입 타이틀
          const Center(
            child: Text(
              '계정 등록',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(height: 24.0),
          _buildTextField(
              controller: _idController,
              hintText: "아이디",
              icon: const Icon(Icons.person),
              validator: (value) {
                _idError = JoinValidate().validateId(value);
              }),
          const SizedBox(height: 8.0),

          _buildTextField(
              controller: _emailController,
              hintText: "이메일",
              icon: Icon(Icons.email),
              validator: (value) {
                _emailError = JoinValidate().validateEmail(value);
              }),
          const SizedBox(height: 8.0),

          _buildTextField(
              controller: _passwordController,
              hintText: "비밀번호",
              icon: Icon(Icons.lock),
              obscureText: true,
              validator: (value) {
                _passwordError =
                    JoinValidate().validatePassword(value, _idController.text);
              }),
          const SizedBox(height: 8.0),

          _buildTextField(
              controller: _confirmPasswordController,
              hintText: "비밀번호 확인",
              icon: Icon(Icons.lock_outline),
              obscureText: true,
              validator: (value) {
                _passwordConfirmError = JoinValidate()
                    .validatePasswordConfirm(value, _passwordController.text);
              }),
          const SizedBox(height: 8.0),

          // 생년월일 필드
          TextFormField(
            controller: _birthdateController,
            decoration: _inputDecoration(
                "생년월일을 선택해주세요", const Icon(Icons.calendar_today)),
            onTap: () {
              _cupertinoDatePicker(context); // 생년월일 선택
            },
            readOnly: true,
          ),
          const SizedBox(height: 24.0),

          // 회원가입 버튼
          ElevatedButton(
            onPressed: _isFormValid ? _register : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(360, 50),
              backgroundColor: _isFormValid ? AppColors.primaryPink : null,
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 12.0), // 버튼 내부 여백 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
              ),
            ),
            child: const Text(
              '등록',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Icon icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required void Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(hintText, icon),
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: (value) {
            setState(() {
              validator(value);
              _updateFormValidity();
            });
          },
        ),
        if (_getErrorMessage(hintText) != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _getErrorMessage(hintText)!,
              style: const TextStyle(color: Colors.red, fontSize: 12.0),
            ),
          ),
      ],
    );
  }

  // 에러 메시지 가져오기
  String? _getErrorMessage(String hintText) {
    switch (hintText) {
      case "아이디":
        return _idError;
      case "이메일":
        return _emailError;
      case "비밀번호":
        return _passwordError;
      case "비밀번호 확인":
        return _passwordConfirmError;
      default:
        return null;
    }
  }

  // 모든 입력값 상태 확인 후 업데이트
  void _updateFormValidity() {
    _isFormValid = _idError == null &&
        _emailError == null &&
        _passwordError == null &&
        _passwordConfirmError == null &&
        _idController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _birthdateController.text.isNotEmpty;
  }

  InputDecoration _inputDecoration(String hintText, Icon icon) {
    return InputDecoration(
      hintText: hintText,
      border: _outlineInputBorder(),
      fillColor: Colors.grey.withOpacity(0.1),
      filled: true,
      prefixIcon: icon,
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }

  Future<void> _register() async {
    String id = _idController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // form 검증 후 회원가입 로직 진행
    if (_formKey.currentState?.validate() ?? false) {
      // 아이디 중복 검사
      if (await isIdDuplicate(id)) {
        setState(() {
          _idError = "이미 존재하는 아이디입니다.";
        });
        return;
      }

      if (await isEmailDuplicate(email)) {
        setState(() {
          _emailError = "이미 존재하는 이메일입니다.";
        });
        return;
      }

      try {
        // Firebase Auth로 사용자 등록
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Firestore에 사용자 정보 저장
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'id': id,
            'email': email,
            'birthdate': _birthdateController.text,
            'isConnected': false, // 초기 연결 상태
          });

          print("회원가입 성공");
          Navigator.pop(context); // 회원가입 완료 후 닫기
        }
      } catch (e) {
        print("회원가입 실패: $e");
        _showErrorMessage("회원가입에 실패했습니다.");
      }
    }
  }

  // 이메일 중복 검사
  Future<bool> isEmailDuplicate(String email) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  // 아이디 중복 검사
  Future<bool> isIdDuplicate(String id) async {
    final QuerySnapshot result =
        await _firestore.collection('users').where('id', isEqualTo: id).get();
    return result.docs.isNotEmpty;
  }

  void _cupertinoDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: 300,
            width: 300,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: _selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        print("생년월일 onDateTimeChanged()");
                        _selectedDate = newDate;
                      });
                    },
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    dateOrder: DatePickerDateOrder.ymd,
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _birthdateController.text =
                        "${_selectedDate?.year}/${_selectedDate?.month}/${_selectedDate?.day}";

                    setState(() {
                      _updateFormValidity();
                    });

                    Navigator.of(context).pop(); // 모달 닫기
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
