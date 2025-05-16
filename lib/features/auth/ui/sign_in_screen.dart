import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/features/auth/ui/widget/forgot_password_button.dart';
import 'package:ouriduri_couple_app/features/connect/request_screen.dart';
import 'package:ouriduri_couple_app/navigation/main_navigation_screen.dart';
import 'package:ouriduri_couple_app/widgets/custom_dialog.dart';
import 'package:ouriduri_couple_app/widgets/custom_elevated_button.dart';
import 'package:ouriduri_couple_app/widgets/custom_text_form_field.dart';

import '../providers/auth_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24.0),
                      const Center(
                        child: Text(
                          '로그인',
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
                        validator: (value) {},
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "비밀번호",
                        icon: const Icon(Icons.key),
                        obscureText: true,
                        validator: (value) {},
                      ),
                      const SizedBox(height: 16.0),
                      const ForgotPasswordButton(),
                      const SizedBox(height: 24.0),
                      CustomElevatedButton(
                        isValidated: true,
                        btnText: "로그인",
                        onPressed: () => _handleSignIn(ref),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn(WidgetRef ref) async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();
    final viewmodel = ref.read(authViewModelProvider.notifier);

    final success = await viewmodel.signInWithId(id, password);
    if (!mounted) return;

    if (success) {
      final isConnected = await viewmodel.checkConnection();
      isConnected ? _navigateToMain() : _navigateToRequest();
    } else {
      CustomDialog.show(context, "아이디 또는 비밀번호가 잘못되었습니다.");
    }
  }

  void _navigateToMain() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  void _navigateToRequest() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RequestScreen()),
    );
  }
}
