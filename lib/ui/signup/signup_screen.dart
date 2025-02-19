import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/interface/signup_listener.dart';
import 'package:ouriduri_couple_app/services/auth_service.dart';
import 'package:ouriduri_couple_app/services/firestore_service.dart';
import 'package:ouriduri_couple_app/ui/signup/signup_screen_viewmodel.dart';
import 'package:ouriduri_couple_app/utils/validation_utils.dart';
import 'package:ouriduri_couple_app/widgets/custom_date_picker.dart';
import 'package:ouriduri_couple_app/widgets/custom_dialog.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../../widgets/input_style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements SignUpListener {
  final _formKey = GlobalKey<FormState>();

  final SignUpScreenViewModel _viewModel = SignUpScreenViewModel(
      authService: AuthService(), fireStoreService: FireStoreService());

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

  // 생년월일 기본 값 설정
  DateTime _selectedDate = DateTime(2000, 1, 1);

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(height: 24.0),

          CustomTextFormField(
            controller: _idController,
            hintText: "아이디",
            icon: const Icon(Icons.person),
            obscureText: false,
            validator: (value) {
              setState(() {
                _idError = JoinValidate().validateId(value);
                _updateFormValidity();
              });
            },
            errorMsg: _idError,
          ),

          const SizedBox(height: 8.0),

          CustomTextFormField(
            controller: _emailController,
            hintText: "이메일",
            icon: const Icon(Icons.email),
            obscureText: false,
            validator: (value) {
              setState(() {
                _emailError = JoinValidate().validateEmail(value);
                _updateFormValidity();
              });
            },
            errorMsg: _emailError,
          ),
          const SizedBox(height: 8.0),

          CustomTextFormField(
            controller: _passwordController,
            hintText: "비밀번호",
            icon: const Icon(Icons.lock),
            obscureText: true,
            validator: (value) {
              setState(() {
                _passwordError =
                    JoinValidate().validatePassword(value, _idController.text);
                _updateFormValidity();
              });
            },
            errorMsg: _passwordError,
          ),
          const SizedBox(height: 8.0),

          CustomTextFormField(
            controller: _confirmPasswordController,
            hintText: "비밀번호 확인",
            icon: const Icon(Icons.lock_outline),
            obscureText: true,
            validator: (value) {
              setState(() {
                _passwordConfirmError = JoinValidate()
                    .validatePasswordConfirm(value, _passwordController.text);
                _updateFormValidity();
              });
            },
            errorMsg: _passwordConfirmError,
          ),
          const SizedBox(height: 8.0),

          // 생년월일 필드
          TextFormField(
            controller: _birthdateController,
            decoration: buildInputDecoration(
                "생년월일을 선택해주세요", const Icon(Icons.calendar_today)),
            onTap: () {
              _cupertinoDatePicker(context);
            },
            readOnly: true,
          ),
          const SizedBox(height: 24.0),

          // 회원가입 버튼
          CustomElevatedButton(
            isValidated: _isFormValid,
            onPressed: () {
              _viewModel.signUp(_idController.text, _emailController.text,
                  _passwordController.text, _birthdateController.text, this);
            },
            btnText: "등록",
          ),
        ],
      ),
    );
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

  void _cupertinoDatePicker(BuildContext context) {
    showCupertinoDialog(
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
                CustomDatePicker(
                    selectedDate: _selectedDate,
                    onDateTimeChanged: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    }),
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

  @override
  void onValidationError(String error) {
    setState(() {
      switch (error) {
        case "idError":
          _idError = "이미 존재하는 아이디입니다.";
          break;
        case "emailError":
          _emailError = "이미 존재하는 이메일입니다.";
          break;
      }
    });
  }

  @override
  void onNavigatorPop() {
    Navigator.pop(context);
  }

  @override
  void onSignUpFailed() {
    setState(() {
      _isFormValid = false;
    });

    showCupertinoDialog(
      context: context,
      builder: (context) => const CustomDialog("회원가입에 실패했습니다."),
    );
  }
}
