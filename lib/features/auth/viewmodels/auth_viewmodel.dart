import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/core/services/firebase_service.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseService _firebaseService;

  AuthViewModel(this._firebaseService);

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<bool> signInWithId(String id, String password) async {
    _setLoading(true);
    _error = null;

    try {
      _user = await _firebaseService.signInWithId(id, password);
      return _user != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkConnection() async {
    return await FirebaseService.isUserConnected();
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    return await _firebaseService.isLoggedIn();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
