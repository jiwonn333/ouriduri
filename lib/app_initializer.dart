import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

import 'core/services/firebase_options.dart';

/**
 * 초기 설정 (Firebase, .env, Kakao 등)
 */

class AppInitializer {
  static Future<void> initialize() async {
    await dotenv.load(fileName: "assets/env/.env");
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_APP_KEY']!);
  }
}
