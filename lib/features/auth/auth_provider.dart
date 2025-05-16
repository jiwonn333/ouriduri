import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';
import 'package:ouriduri_couple_app/features/auth/repositories/auth_repository_impl.dart';

import 'domain/repositories/auth_repository.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return AuthRepositoryImpl(firebaseService);
});
