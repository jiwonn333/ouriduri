import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:ouriduri_couple_app/services/firebase_options.dart';
import 'package:ouriduri_couple_app/ui/connect/connect_screen.dart';
import 'package:ouriduri_couple_app/ui/intro/home_screen.dart';
import 'package:ouriduri_couple_app/ui/intro/start_screen.dart';
import 'package:ouriduri_couple_app/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/env/.env");
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_APP_KEY']!);

  // runApp(const MainPage());
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: const ConnectScreen(),
      ),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 상태바 배경 투명
        statusBarIconBrightness: Brightness.light, // 상태바 아이콘 검정색
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.transparent, // AppBar와 관련된 색상 제거
          ),
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
              return const HomeScreen(); // 로그인 된 경우
            } else {
              return const StartScreen();
            }
          },
        ),
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

  Future<String> getAppKey() async {
    // iOS에서는 Info.plist에서 직접 값을 가져오는 방식
    final String appKey = await rootBundle.loadString("Info.plist");
    return jsonDecode(appKey)['KAKAO_APP_KEY'];
  }
}
