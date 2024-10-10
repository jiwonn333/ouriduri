import 'package:flutter/material.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // 회원가입 로직 구현 (Firebase Firestore에 데이터 저장 등)
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
                ),
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

  Widget _buildInputFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "이메일",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력하세요';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
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
                return '아이디를 입력하세요';
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
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력하세요';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              hintText: "비밀번호 확인",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 다시 입력하세요';
              }
              if (value != _passwordController.text) {
                return '비밀번호가 일치하지 않습니다';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              hintText: "생년월일 (예: 2000/01/01)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '생년월일을 입력하세요';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}