import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:ouriduri_couple_app/services/firebase_options.dart';
import 'package:ouriduri_couple_app/services/firebase_service.dart';
import 'package:ouriduri_couple_app/ui/connect/request_screen.dart';
import 'package:ouriduri_couple_app/ui/connect/response_screen.dart';
import 'package:ouriduri_couple_app/ui/intro/home_screen.dart';
import 'package:ouriduri_couple_app/ui/intro/start_screen.dart';
import 'package:ouriduri_couple_app/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/env/.env");
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_APP_KEY']!);

  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Widget _currentScreen = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// 초기 앱 실행 처리
  Future<void> _initializeApp() async {
    _appLinks = AppLinks();

    // 1. 로그인 및 커플 연결 상태 확인
    _checkAuthStatus();

    // 2. 초기 딥링크 확인
    Uri? initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // 3. 실시간 딥링크 감지
    _setupDeepLinkListener();
  }

  /// 로그인 여부 & 커플 연결 상태 확인
  Future<void> _checkAuthStatus() async {
    bool isLoggedIn = await FirebaseService.isUserLoggedIn();
    if (!isLoggedIn) {
      // 로그인되지 않은 경우
      setState(() {
        print("⏸️ 로그인 되지 않은 경우");
        _currentScreen = const StartScreen(); // StartScreen으로 이동
      });
      return;
    } else {
      bool isConnected = await FirebaseService.isUserConnected();
      if (isConnected) {
        // 커플 연결된 경우
        setState(() {
          print("⏸️ 커플 연결된 경우");
          _currentScreen = const HomeScreen(); // HomeScreen으로 이동
        });
      } else {
        // 커플 연결되지 않은 경우
        setState(() {
          print("⏸️ 커플 연결되지 않은 경우");
          _currentScreen = const RequestScreen(); // RequestScreen으로 이동
        });
      }
    }
  }

  /// 실시간 딥링크 감지 설정
  void _setupDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) => print("❌ 딥링크 오류 발생: $err"),
    );
  }

  /// 딥링크 감지 후 화면 이동 처리
  void _handleDeepLink(Uri uri) {
    print("📡 딥링크 감지됨: $uri");
    print("🔍 1. 전체 URI: $uri");
    print("🔍 2. URI path: '${uri.path}'");
    print("🔍 3. URI pathSegments: ${uri.pathSegments}");
    print("🔍 4. URI host: ${uri.host}");
    print("🔍 5. URI queryParameters: ${uri.queryParameters}");

    String? inviteCode = uri.queryParameters["invite_code"];

    // 경로가 비어있다면 uri.host를 대신 사용
    String path = uri.path.isNotEmpty ? uri.path : uri.host;

    if (path == "response_screen" && inviteCode != null) {
      print("✅ 이동: /response_screen (초대 코드: $inviteCode)");
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _navigatorKey.currentState?.push(
      //     MaterialPageRoute(
      //       builder: (context) => ResponseScreen(inviteCode: inviteCode),
      //     ),
      //   );
      // });
      if (mounted) {
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponseScreen(inviteCode: inviteCode),
          ),
        );
      }
    } else {
      print("❌ 이동 실패: URI path가 비어있거나 invite_code가 없음.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Ouriduri App',
      theme: ThemeData(
        fontFamily: 'Ouriduri',
        scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ko', '')],
      home: FutureBuilder<bool>(
        future: FirebaseService.isUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data == true) {
            return FutureBuilder<bool>(
              future: FirebaseService.isUserConnected(), // ✅ 커플 연결 여부 확인
              builder: (BuildContext context, AsyncSnapshot<bool> connectedSnapshot) {
                if (connectedSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (connectedSnapshot.hasData && connectedSnapshot.data == true) {
                  return const HomeScreen(); // ✅ 커플 연결된 경우
                } else {
                  return const RequestScreen(); // ✅ 커플 연결되지 않은 경우
                }
              },
            );
          } else {
            return const StartScreen(); // ✅ 로그인되지 않은 경우
          }
        },
      ),

      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/response_screen') {
          final String inviteCode = settings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => ResponseScreen(inviteCode: inviteCode));
        }
        return null;
      },
    );
  }
}
