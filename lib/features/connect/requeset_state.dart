class RequestState {
  final String inviteCode;
  final bool isConnected;
  final bool isLoading;
  final String? errorMessage;

  RequestState({
    required this.inviteCode,
    required this.isConnected,
    required this.isLoading,
    this.errorMessage,
  });

  RequestState copyWith({
    String? inviteCode,
    bool? isConnected,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RequestState(
      inviteCode: inviteCode ?? this.inviteCode,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory RequestState.initial() {
    return RequestState(
        inviteCode: '',
        isConnected: false,
        isLoading: false,
        errorMessage: null);
  }
}
