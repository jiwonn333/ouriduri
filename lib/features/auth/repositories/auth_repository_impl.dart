import 'package:ouriduri_couple_app/features/auth/domain/entities/app_user.dart';
import 'package:ouriduri_couple_app/features/auth/domain/repositories/auth_repository.dart';

import '../../../core/services/firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;

  AuthRepositoryImpl(this._firebaseService);

  @override
  Future<AppUser?> signInWithId(String id, String password) async {
    final firebaseUser = await _firebaseService.signInWithId(id, password);
    if (firebaseUser == null) return null;
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email ?? '');
  }

  @override
  Future<bool> isLoggedIn() {
    return _firebaseService.isLoggedIn();
  }

  @override
  Future<void> signOut() {
    return _firebaseService.signOut();
  }

  @override
  Future<bool> isUserConnected() {
    return FirebaseService.isUserConnected();
  }
}
