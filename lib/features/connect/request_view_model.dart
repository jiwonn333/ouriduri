// lib/viewmodel/request/request_view_model.dart

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:ouriduri_couple_app/features/connect/requeset_state.dart';

class RequestViewModel extends StateNotifier<RequestState> {
  RequestViewModel() : super(RequestState.initial());

  Future<void> init() async {
    final code = _generateRandomCode();
    await _saveInviteCodeToFirestore(code);
    state = state.copyWith(inviteCode: code);
    _listenConnectionStatus();
  }

  void _listenConnectionStatus() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen(
      (doc) {
        final data = doc.data();
        if (data?['isConnected'] == true) {
          state = state.copyWith(isConnected: true);
        }
      },
    );
  }

  // 초대 코드 랜덤 생성 (9자리)
  String _generateRandomCode({int length = 9}) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length,
              (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

  // Firestore에 초대 코드 저장
  Future<void> _saveInviteCodeToFirestore(String code) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'inviteCode': code,
      });
    }
  }

  // 카카오톡 공유 기능
  Future<void> shareToKakao() async {
    try {
      state = state.copyWith(isLoading: true);

      final template = TextTemplate(
        text: 'OuriDuri 초대 코드: ${state.inviteCode}\n복사 후 앱에서 연결을 진행해주세요!',
        link: Link(
          webUrl: Uri.parse('https://yourwebsite.com/invite?code=${state.inviteCode}'),
          // 웹 Fallback URL
          mobileWebUrl:
          Uri.parse('https://yourwebsite.com/invite?code=${state.inviteCode}'),
          androidExecutionParams: {'invite_code': state.inviteCode},
          // Android 앱에서 실행할 딥링크
          iosExecutionParams: {'invite_code': state.inviteCode}, // iOS 앱에서 실행할 딥링크
        ),
      );

      if (await ShareClient.instance.isKakaoTalkSharingAvailable()) {
        final uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
      } else {
        final shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: template);
        // await launchUrlString(shareUrl.toString());
        await launchBrowserTab(shareUrl, popupOpen: true);
      }
    } catch (error) {
      state = state.copyWith(errorMessage: '카카오톡 공유 실패 : $error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


}

final requestViewModelProvider =
    StateNotifierProvider<RequestViewModel, RequestState>((ref) {
  return RequestViewModel()..init();
});
