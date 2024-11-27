import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/utils/validation_utils.dart';

import 'utils/app_colors.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();

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

  // 생년월일 기본 값 설정 (현재 날짜)
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("회원가입"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                _buildInputFields(),
                _btnJoin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        /** !!!!! 회원가입에 맞는 이미지로 변경 !!!!! **/
        // Image.asset('assets/join.png'),
      ],
    );
  }

  Widget _btnJoin() {
    return ElevatedButton(
      onPressed: () async {
        // form 검증 후 회원가입 로직 진행
        if (_formKey.currentState?.validate() ?? false) {

          // 이메일 중복 검사
          if(await isEmailDuplicate(_emailController.text.trim())) {
            showErrorDialog(context, "이미 사용중인 이메일입니다.");
            return;
          }
          // 아이디 중복 검사
          if(await isIdDuplicate(_idController.text.trim())) {
            showIdDialog(context, "이미 사용중인 아이디입니다.");
            return;
          }


          try {
            // 회원가입 로직 구현 (Firebase Firestore에 데이터 저장 등)
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim());

            await _firestore
                .collection('users')
                .doc(userCredential.user?.uid)
                .set({
              'id': _idController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text.trim(), /// 비밀번호는 저장 x, 저장하려면 암호화시켜서 (나중에 수정)
              'birthdate': _birthdateController.text.trim()
            });

            // 회원가입 성공 시 처리
            showSignUpSuccessDialog(context);
          } catch (e) {
            print("회원가입 실패: $e");
          }
        }
      },
      child: Text(
        "회원가입",
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 이메일 필드
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration("이메일", Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => JoinValidate().validateEmail(value),
          ),
          const SizedBox(height: 10),

          // 아이디 필드
          TextFormField(
            controller: _idController,
            decoration: _inputDecoration("아이디", Icon(Icons.person)),
            validator: (value) => JoinValidate().validateId(value),
          ),
          const SizedBox(height: 10),

          // 비밀번호 필드
          TextFormField(
            controller: _passwordController,
            decoration: _inputDecoration("비밀번호", Icon(Icons.lock)),
            obscureText: true,
            validator: (value) => JoinValidate()
                .validatePassword(value, _idController.text.trim()),
          ),
          const SizedBox(height: 10),

          // 비밀번호 확인 필드
          TextFormField(
            controller: _confirmPasswordController,
            decoration: _inputDecoration("비밀번호 확인", Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) => JoinValidate()
                .validatePasswordConfirm(value, _passwordController),
          ),
          const SizedBox(height: 10),

          // 생년월일 필드
          TextFormField(
            controller: _birthdateController,
            decoration:
                _inputDecoration("생년월일을 선택해주세요", Icon(Icons.calendar_today)),
            onTap: () {
              // 생년월일 선택을 위해 cupertinoDatePicker 호출
              _cupertinoDatePicker(context);
            },
            readOnly: true,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
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
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    );
  }

  void _cupertinoDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
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
                    initialDateTime: DateTime(2000, 1, 1),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        _birthdateController.text =
                            "${newDate.year}/${newDate.month}/${newDate.day}"; // 선택한 날짜를 포맷하여 TextFormField에 표시
                      });
                    },
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    dateOrder: DatePickerDateOrder.ymd, // 기본 날짜 형식 순서 지정
                  ),
                ),
                SizedBox(height: 10),
                CupertinoButton(
                  child: Text('확인'),
                  onPressed: () {
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

  void showSignUpSuccessDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("회원가입 성공"),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
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
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    return result.docs.isNotEmpty;
  }

  void showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      ),
    );
  }

  void showIdDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      ),
    );
  }

}
