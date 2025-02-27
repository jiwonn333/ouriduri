import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/signup_screen_viewmodel.dart';
import 'package:ouriduri_couple_app/interface/signup_listener.dart';
import 'package:ouriduri_couple_app/widgets/custom_dialog.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/utils/validation_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements SignUpListener {
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  bool _isFormValid = false;

  final SignUpScreenViewModel _viewModel = SignUpScreenViewModel(
      authService: AuthService(), fireStoreService: FireStoreService());

  // 실시간 에러 메시지 저장
  String? _idError;
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmError;
  String? _nicknameError;

  // 입력 컨트롤러
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _signUpAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  AppBar _signUpAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
      title: const Text(
        "회원가입",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),

      leading: currentStep > 0
          ? IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () {
                setState(() {
                  currentStep--; // 이전 스텝으로 이동
                  _updateStepValidity(currentStep, null);
                });
              },
            )
          : null, // 첫 번째 스텝이면 뒤로가기 버튼 없음
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
          Text(
            _getStepTitle(currentStep),
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(height: 24.0),
          _buildStepContent(),
          const SizedBox(height: 24.0),
          CustomElevatedButton(
            isValidated: _isFormValid,
            onPressed: _handleNextStep,
            btnText: currentStep < 3 ? "다음" : "회원가입",
          ),
        ],
      ),
    );
  }

  // 현재 스텝에 맞는 콘텐츠 표시
  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return CustomTextFormField(
          controller: _idController,
          hintText: "아이디",
          icon: const Icon(Icons.person),
          obscureText: false,
          validator: _validateId,
          // 유효성 검사 메서드 사용
          errorMsg: _idError,
        );
      case 1:
        return CustomTextFormField(
          controller: _emailController,
          hintText: "이메일",
          icon: const Icon(Icons.email_outlined),
          obscureText: false,
          validator: _validateEmail,
          // 유효성 검사 메서드 사용
          errorMsg: _emailError,
        );
      case 2:
        return Column(
          children: [
            CustomTextFormField(
              controller: _passwordController,
              hintText: "비밀번호",
              icon: const Icon(Icons.lock),
              obscureText: true,
              validator: _validatePassword,
              errorMsg: _passwordError,
            ),
            const SizedBox(height: 8.0),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: "비밀번호 확인",
              icon: const Icon(Icons.lock_outline),
              obscureText: true,
              validator: _validatePasswordConfirm,
              errorMsg: _passwordConfirmError,
            ),
          ],
        );
      case 3:
        return TextFormField(
          controller: _nicknameController,
          decoration: InputDecoration(
            hintText: "닉네임",
            prefixIcon: const Icon(Icons.account_circle),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: _nicknameError,
            errorStyle: const TextStyle(
                color: Colors.red, fontSize: 12.0), // ✅ 다른 필드와 동일한 스타일 적용
          ),
          validator: _validateNickname,
          onChanged: (value) {
            if (value.length > 12) {
              _nicknameController.value = TextEditingValue(
                text: value.substring(0, 12),
                selection: const TextSelection.collapsed(offset: 12),
              );
            }
            setState(() {
              _nicknameError = _validateNickname(value);
            });
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(
                r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
          ],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLength: 12,
        );
      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     TextFormField(
      //       controller: _nicknameController,
      //       decoration: InputDecoration(
      //         hintText: "닉네임",
      //         prefixIcon: const Icon(Icons.account_circle),
      //         fillColor: Colors.grey.withOpacity(0.1),
      //         filled: true,
      //         border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(10),
      //           borderSide: BorderSide.none,
      //         ),
      //         errorText: _nicknameError,
      //       ),
      //       validator: _validateNickname,
      //       onChanged: (value) {
      //         if (value.length > 12) {  // ✅ 잘못된 `300` → `12`로 변경
      //           _nicknameController.value = TextEditingValue(
      //             text: value.substring(0, 12), // ✅ 12자로 강제 제한
      //             selection: TextSelection.collapsed(offset: 12),
      //           );
      //         }
      //         setState(() {
      //           _nicknameError = _validateNickname(value); // ✅ 실시간 유효성 검사
      //         });
      //       },
      //       inputFormatters: [
      //         FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
      //       ],
      //       keyboardType: TextInputType.text,
      //       textInputAction: TextInputAction.done,
      //       maxLength: 12, // ✅ 최대 길이 설정 (입력 초과 방지)
      //     ),
      //   ],
      // );
      default:
        return Container();
    }
  }

  // 스텝에 맞는 유효성 검사
  void _updateStepValidity(int step, String? error) {
    switch (step) {
      case 0:
        setState(() {
          _idError = error;
          _isFormValid = _idError == null && _idController.text.isNotEmpty;
        });
        break;
      case 1:
        setState(() {
          _emailError = error;
          _isFormValid =
              _emailError == null && _emailController.text.isNotEmpty;
        });
        break;
      case 2:
        setState(() {
          _passwordError = error;
          _passwordConfirmError = error;
          bool isPasswordValid = _passwordError == null &&
              _passwordConfirmError == null &&
              _passwordController.text.isNotEmpty &&
              _confirmPasswordController.text.isNotEmpty &&
              _passwordController.text == _confirmPasswordController.text;
          _isFormValid = isPasswordValid;
        });
        break;
      case 3:
        setState(() {
          _nicknameError = error;
          _isFormValid =
              _nicknameError == null && _nicknameController.text.isNotEmpty;
        });
        break;
      default:
        setState(() {
          _isFormValid = false;
        });
    }
  }

  /// 0. 아이디 유효성 검사
  String? _validateId(String? id) {
    String? error = JoinValidate().validateId(id);
    _updateStepValidity(0, error); // 유효성 검사 후 버튼 상태 업데이트
    return error;
  }

  /// 1. 이메일 유효성 검사
  String? _validateEmail(String? email) {
    String? error = JoinValidate().validateEmail(email);
    _updateStepValidity(1, error);
    return error;
  }

  /// 2-1. 비밀번호, 비밀번호 확인 유효성 검사
  String? _validatePassword(String? password) {
    String? error =
        JoinValidate().validatePassword(password, _idController.text);
    _updateStepValidity(2, error);
    return error;
  }

  /// 2-2. 비밀번호, 비밀번호 확인 유효성 검사
  String? _validatePasswordConfirm(String? confirmPassword) {
    String? error = JoinValidate().validatePasswordConfirm(
        confirmPassword, _confirmPasswordController.text);
    _updateStepValidity(2, error);
    return error;
  }

  /// 3. 닉네임 유효성 검사
  String? _validateNickname(String? nickname) {
    String? error = JoinValidate().validateNickname(nickname);
    _updateStepValidity(3, error);
    return error;
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

  void _handleNextStep() async {
    if (!_formKey.currentState!.validate()) return;

    switch (currentStep) {
      case 0:
        _checkDuplicate(
            _viewModel.checkIdDuplicate, _idController.text, "이미 존재하는 아이디입니다.",
            (error) {
          _idError = error;
        });
        break;
      case 1:
        _checkDuplicate(_viewModel.checkEmailDuplicate, _emailController.text,
            "이미 존재하는 이메일입니다.", (error) {
          _emailError = error;
        });
        break;
      case 2:
        if (_passwordController.text != _confirmPasswordController.text) {
          setState(() {
            _passwordError = "비밀번호가 일치하지 않습니다.";
          });
          return;
        }
        _goToNextStep();
        break;
      case 3:
        _signUp();
        break;
    }
  }

  Future<void> _checkDuplicate(Future<bool> Function(String) checkFunction,
      String value, String errorMessage, Function(String?) setError) async {
    bool isDuplicate = await checkFunction(value);
    if (isDuplicate) {
      setState(() {
        setError(errorMessage);
        _isFormValid = false;
      });
      return;
    }
    _goToNextStep();
  }

  void _goToNextStep() {
    setState(() {
      currentStep++;
      _isFormValid = false;
    });
  }

  void _signUp() {
    _viewModel.signUp(
      _idController.text,
      _emailController.text,
      _passwordController.text,
      _nicknameController.text,
      this,
    );
  }

  String _getStepTitle(int step) {
    return ["아이디를 입력해주세요", "이메일을 입력해주세요", "비밀번호를 입력해주세요", "닉네임을 입력해주세요"][step];
  }

// String _getStepTitle(int step) {
//   switch (step) {
//     case 0:
//       return "아이디를 입력해주세요";
//     case 1:
//       return "이메일을 입력해주세요";
//     case 2:
//       return "비밀번호를 입력해주세요";
//     case 3:
//       return "닉네임을 입력해주세요";
//     default:
//       return "계정 등록";
//   }
// }
}
