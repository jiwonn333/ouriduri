import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/home.dart';
import 'package:ouriduri_couple_app/validate.dart';

import 'app_colors.dart';
import 'join.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildInputFields(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextButton(context, "아이디 찾기", _findId),
                      _buildTextButton(context, "비밀번호 찾기", _findPassword),
                      _buildTextButton(context, "회원가입", _joinPage),
                    ],
                  ),
                  // 로고 들어가는 부분
                  SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/login_logo.png'),
        ));
  }

  Widget _buildInputFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _idController,
            decoration: _inputDecoration("아이디", Icon(Icons.person)),
            validator: (value) => JoinValidate().validateId(value),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: _inputDecoration("비밀번호", Icon(Icons.key)),
            obscureText: true,
            validator: (value) => JoinValidate()
                .validatePassword(value, _idController.text.trim()),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _login,
            child: Text(
              "로그인",
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          '@ouriduri',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _findId() {
    // 아이디 찾기 로직 구현
  }

  void _findPassword() {
    // 비밀번호 찾기 로직 구현
  }

  void _joinPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinPage(),
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

  Future<void> _login() async {
    String? email = await _getEmailFromUserId(_idController.text);

    if (email != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: _passwordController.text);
        if (userCredential.user != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          print("로그인 성공");
        }
      } catch (e) {
        print("로그인실패: $e");
      }
    } else {
      print("해당 아이디에 대한 이메일을 찾을 수 없습니다.");
    }
  }

  // Firestore에서 아이디로 이메일 찾기
  Future<String?> _getEmailFromUserId(String userId) async {
    try {
      // 아이디로 firestore에서 이메일 찾기
      QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first['email']; // 이메일 반환
      } else {
        print('아이디가 존재하지 않음');
        return null;
      }
    } catch (e) {
      print("이메일 찾기 실패: $e");
      return null;
    }
  }
}
