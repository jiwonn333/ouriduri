import 'package:ouriduri_couple_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithId(String id, String password);

  Future<bool> isLoggedIn();

  Future<void> signOut();

  Future<bool> isUserConnected();
}
