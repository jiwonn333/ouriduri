import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ouriduri_couple_app/home.dart';
import 'package:ouriduri_couple_app/screens/onboarding/start_screen.dart';
import 'package:ouriduri_couple_app/services/firebase_options.dart';
import 'package:ouriduri_couple_app/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ouriduri',
        scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
        splashColor: Colors.transparent,
        // 클릭 시 리플 색상 투명하게 설정
        highlightColor: Colors.transparent,
        // 선택 시 하이라이트 색상 투명하게 설정
        splashFactory: NoSplash.splashFactory, // 리플 효과 비활성화화
      ),
      title: 'Ouriduri App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, //  추가
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      // home: LoginPage()
      home: FutureBuilder<bool>(
        future: checkUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // 로딩 표시
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Future 작업 완료 후 데이터 확인하고 화면 결정
          else if (snapshot.hasData && snapshot.data == true) {
            return const HomePage(); // 로그인 된 경우
          } else {
            return StartScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkUserLoggedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      await currentUser?.reload(); // 사용자 세션 갱신
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // 계정이 삭제되었거나 세션이 유효하지 않은 경우 로그아웃
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }
}
