import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/auth_view_model.dart';

/// FirebaseService를 주입할 Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// AuthViewModel을 관리하는 ChangeNotifierProvider
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return AuthViewModel(firebaseService);
});
