import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/terms/terms_state.dart';

/// 상태 관리

class TermsViewModel extends StateNotifier<TermsState> {
  TermsViewModel() : super(TermsState());

  void toggleAllAgreed(bool value) {
    state = state.copyWith(
      isAllAgreed: value,
      isAgeOver14: value,
      isServiceAgreed: value,
      isPrivacyAgreed: value,
    );
  }

  void toggleAgeOver14(bool value) {
    final isAllAgreed = value && state.isServiceAgreed && state.isPrivacyAgreed;
    state = state.copyWith(
      isAgeOver14: value,
      isAllAgreed: isAllAgreed,
    );
  }

  void toggleServiceAgreed(bool value) {
    final isAllAgreed = value && state.isPrivacyAgreed && state.isAgeOver14;
    state = state.copyWith(
      isServiceAgreed: value,
      isAllAgreed: isAllAgreed,
    );
  }

  void togglePrivacyAgreed(bool value) {
    final isAllAgreed = value && state.isServiceAgreed && state.isAgeOver14;
    state = state.copyWith(
      isPrivacyAgreed: value,
      isAllAgreed: isAllAgreed,
    );
  }
}

final termsViewModelProvider =
    StateNotifierProvider<TermsViewModel, TermsState>(
  (ref) => TermsViewModel(),
);
