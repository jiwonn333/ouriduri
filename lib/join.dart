import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/validate.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  // 회원가입 시 Firestore에 아이디와 이메일 저장
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 생년월일
  DateTime _selectedDate = DateTime.now();

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
        if (_formKey.currentState?.validate() ?? false) {
          try {
            // 회원가입 로직 구현 (Firebase Firestore에 데이터 저장 등)
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim());

            await _firestore
                .collection('users')
                .doc(userCredential.user?.uid)
                .set({'id': _idController, 'email': _emailController});

            // 회원가입 성공 시 처리 (로그인 페이지로 이동)
            Navigator.pop(context);
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
        backgroundColor: Color(0xffff9094),
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
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration("이메일", Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => JoinValidate().validateEmail(value),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _idController,
            decoration: _inputDecoration("아이디", Icon(Icons.person)),
            validator: (value) => JoinValidate().validateId(value),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: _inputDecoration("비밀번호", Icon(Icons.lock)),
            obscureText: true,
            validator: (value) => JoinValidate().validatePassword(value),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: _inputDecoration("비밀번호 확인", Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) => JoinValidate()
                .validatePasswordConfirm(value, _passwordController),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _birthdateController,
            decoration:
                _inputDecoration("생년월일을 선택해주세요", Icon(Icons.calendar_today)),
            onTap: () {
              _cupertinoDatePicker(context);
            },
            // onTap: () async {
            //   final selectedDate = await showDatePicker(
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(1970),
            //     lastDate: DateTime.now(),
            //   );
            //   if(birthDate != null) {
            //     // 생년월일 받아오기
            //     // birthDate = selectedDate!;
            //   }
            // },
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
                            "${newDate.year}-${newDate.month}-${newDate.day}"; // 선택한 날짜를 포맷하여 TextFormField에 표시
                      });
                    },
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
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
}
