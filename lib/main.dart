import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_initializer.dart';
import 'features/splash/splash_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  try {
    await AppInitializer.initialize();
    runApp(const ProviderScope(child: OuriDuriApp()));
  } catch (e, stack) {
    debugPrint('🔥 Firebase 초기화 실패: $e');
    debugPrintStack(stackTrace: stack);
  }

  // 강제 로그아웃 테스트 (앱 삭제 후에도 로그인 유지되는지 확인)
  // await FirebaseAuth.instance.signOut();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); -> app_initializer
  // await dotenv.load(fileName: "assets/env/.env"); -> app_initializer
  // KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_APP_KEY']!); -> app_initializer

  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => HomeBaseViewModel()),
  //       ChangeNotifierProvider(create: (_) => CalendarViewModel()),
  //     ],
  //     child: const MainPage(),
  //   ),
  // );
}

class OuriDuriApp extends StatelessWidget {
  const OuriDuriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ouriduri App',
      theme: ThemeData(
        fontFamily: 'Ouriduri',
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const SplashRouter(),
    );
  }
}

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
//   late AppLinks _appLinks;
//   StreamSubscription<Uri>? _linkSubscription;
//   Widget _currentScreen = const Center(child: CircularProgressIndicator());
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }
//
//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//     super.dispose();
//   }
//
//   /// 초기 앱 실행 처리
//   Future<void> _initializeApp() async {
//     _appLinks = AppLinks();
//
//     // 1. 로그인 및 커플 연결 상태 확인
//     _checkAuthStatus();
//
//     // 2. 초기 딥링크 확인
//     Uri? initialUri = await _appLinks.getInitialAppLink();
//     if (initialUri != null) {
//       _handleDeepLink(initialUri);
//     }
//
//     // 3. 실시간 딥링크 감지
//     _setupDeepLinkListener();
//   }
//
//   /// 로그인 여부 & 커플 연결 상태 확인
//   Future<void> _checkAuthStatus() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform); // Firebase 초기화
//     bool isLoggedIn = await FirebaseService.isUserLoggedIn();
//     if (!isLoggedIn) {
//       // ✅ 로그인되지 않은 경우 StartScreen으로 설정
//       if (mounted) {
//         setState(() {
//           _currentScreen = const StartScreen();
//         });
//       }
//       return;
//     } else {
//       bool isConnected = await FirebaseService.isUserConnected();
//       if (mounted) {
//         setState(() {
//           // 기본적으로 StartScreen 으로 설정
//           _currentScreen = const StartScreen();
//         });
//
//         if (!isConnected) {
//           // ✅ 커플 연결이 안 된 경우, StartScreen 위에 RequestScreen 띄우기
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _navigatorKey.currentState?.push(
//               MaterialPageRoute(builder: (context) => const RequestScreen()),
//             );
//           });
//         }
//       }
//     }
//   }
//
//   /// 실시간 딥링크 감지 설정
//   void _setupDeepLinkListener() {
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//       (Uri? uri) {
//         if (uri != null) {
//           _handleDeepLink(uri);
//         }
//       },
//       onError: (err) => print("❌ 딥링크 오류 발생: $err"),
//     );
//   }
//
//   /// 딥링크 감지 후 화면 이동 처리
//   void _handleDeepLink(Uri uri) {
//     print("📡 딥링크 감지됨: $uri");
//     print("🔍 1. 전체 URI: $uri");
//     print("🔍 2. URI path: '${uri.path}'");
//     print("🔍 3. URI pathSegments: ${uri.pathSegments}");
//     print("🔍 4. URI host: ${uri.host}");
//     print("🔍 5. URI queryParameters: ${uri.queryParameters}");
//
//     String? inviteCode = uri.queryParameters["invite_code"];
//
//     // 경로가 비어있다면 uri.host를 대신 사용
//     String path = uri.path.isNotEmpty ? uri.path : uri.host;
//
//     if (path == "response_screen" && inviteCode != null) {
//       print("✅ 이동: /response_screen (초대 코드: $inviteCode)");
//       // WidgetsBinding.instance.addPostFrameCallback((_) {
//       //   _navigatorKey.currentState?.push(
//       //     MaterialPageRoute(
//       //       builder: (context) => ResponseScreen(inviteCode: inviteCode),
//       //     ),
//       //   );
//       // });
//       if (mounted) {
//         _navigatorKey.currentState?.pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => ResponseScreen(inviteCode: inviteCode),
//           ),
//         );
//       }
//     } else {
//       print("❌ 이동 실패: URI path가 비어있거나 invite_code가 없음.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: _navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Ouriduri App',
//       theme: ThemeData(
//         fontFamily: 'Ouriduri',
//         scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         splashFactory: NoSplash.splashFactory,
//       ),
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: const [Locale('en', ''), Locale('ko', '')],
//       home: _currentScreen,
//       onGenerateRoute: (RouteSettings settings) {
//         if (settings.name == '/response_screen') {
//           final String inviteCode = settings.arguments as String;
//           return MaterialPageRoute(
//               builder: (context) => ResponseScreen(inviteCode: inviteCode));
//         }
//         return null;
//       },
//     );
//   }
// }
