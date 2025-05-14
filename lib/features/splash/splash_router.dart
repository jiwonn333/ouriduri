/**
 * 기존 MainPage 역할
 */
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';
import 'package:ouriduri_couple_app/features/auth/ui/start_screen.dart';
import 'package:ouriduri_couple_app/features/connect/request_screen.dart';
import 'package:ouriduri_couple_app/features/connect/response_screen.dart';
import 'package:ouriduri_couple_app/features/home/screens/home_base_screen.dart';

import '../../navigation/main_navigation_screen.dart';
import 'splash_state.dart';

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  SplashState _state = SplashState.loading;
  String? _inviteCode;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    final isLoggedIn = await FirebaseService.isUserLoggedIn();
    if (!isLoggedIn) {
      setState(() => _state = SplashState.notLoggedIn);
      return;
    }

    final isConnected = await FirebaseService.isUserConnected();
    setState(() {
      _state = isConnected ? SplashState.connected : SplashState.notConnected;
    });

    // 딥링크 초기 감지
    final initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) _handleDeepLink(initialUri);

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    final inviteCode = uri.queryParameters["invite_code"];
    if (uri.path == "response_screen" && inviteCode != null) {
      setState(() {
        _inviteCode = inviteCode;
        _state = SplashState.deepLinkResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_state) {
      case SplashState.loading:
        child = const Center(child: CircularProgressIndicator());
        break;
      case SplashState.notLoggedIn:
        child = const StartScreen();
        break;
      case SplashState.notConnected:
        child = Stack(
          children: const [
            StartScreen(),
            RequestScreen(), // 요청창은 항상 Start 위에 push된 느낌
          ],
        );
        break;
      case SplashState.connected:
        child = const MainNavigationScreen(); // MainNavigationScreen으로 변경
        break;
      case SplashState.deepLinkResponse:
        child = ResponseScreen(inviteCode: _inviteCode!);
        break;
    }

    return child;
  }
}
