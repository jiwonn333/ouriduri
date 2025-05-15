import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';
import 'package:ouriduri_couple_app/features/auth/viewmodels/auth_viewmodel.dart';

/// FirebaseService를 주입할 Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// AuthViewModel을 관리하는 ChangeNotifierProvider
final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final firebaseService = FirebaseService();
  return AuthViewModel(firebaseService);
});
