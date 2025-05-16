import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final FirebaseService _firebaseService;

  AuthViewModel(this._firebaseService) : super(const AsyncValue.data(null));

  Future<bool> signInWithId(String id, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _firebaseService.signInWithId(id, password);

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
    return await FirebaseService.isUserConnected();
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    state = const AsyncValue.data(null);
  }

  Future<bool> isLoggedIn() async {
    return await _firebaseService.isLoggedIn();
  }
}
