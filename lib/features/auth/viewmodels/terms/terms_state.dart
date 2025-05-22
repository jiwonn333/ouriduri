/// 약관 동의 상태를 나타내는 클래스

class TermsState {
  final bool isAllAgreed;
  final bool isAgeOver14;
  final bool isServiceAgreed;
  final bool isPrivacyAgreed;

  TermsState({
    this.isAllAgreed = false,
    this.isAgeOver14 = false,
    this.isServiceAgreed = false,
    this.isPrivacyAgreed = false,
  });

  TermsState copyWith({
    bool? isAllAgreed,
    bool? isAgeOver14,
    bool? isServiceAgreed,
    bool? isPrivacyAgreed,
  }) {
    return TermsState(
      isAllAgreed: isAllAgreed ?? this.isAllAgreed,
      isAgeOver14: isAgeOver14 ?? this.isAgeOver14,
      isServiceAgreed: isServiceAgreed ?? this.isServiceAgreed,
      isPrivacyAgreed: isPrivacyAgreed ?? this.isPrivacyAgreed,
    );
  }
}
