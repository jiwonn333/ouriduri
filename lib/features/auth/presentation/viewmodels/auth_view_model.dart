import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/features/auth/domain/entities/app_user.dart';
import 'package:ouriduri_couple_app/features/auth/domain/repositories/auth_repository.dart';

import '../../auth_provider.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<AppUser?>>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthViewModel(const AsyncValue.data(null), authRepository);
});

class AuthViewModel extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _authRepository;

  AuthViewModel(super.state, this._authRepository);

  Future<bool> signInWithId(String id, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithId(id, password);
      if (user != null) {
        state = AsyncValue.data(user);
        return true;
      } else {
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> checkConnection() async {
    return await _authRepository.isUserConnected();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AsyncValue.data(null);
  }

  Future<bool> isLoggedIn() async {
    return await _authRepository.isLoggedIn();
  }
}
