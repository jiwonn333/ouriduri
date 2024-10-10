import 'package:flutter/material.dart';

import 'join.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            decoration: InputDecoration(
              hintText: "아이디",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "아이디를 입력하세요";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "비밀번호",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.key),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "비밀번호를 입력하세요";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // 로그인 로직 구현
              }
            },
            child: Text(
              "로그인",
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
}