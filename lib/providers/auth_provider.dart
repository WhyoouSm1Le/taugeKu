import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:taugeku_mobile03/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    // Dengarkan status login dari Firebase.
    _subscription = _authService.authStateChanges.listen(_onAuthChanged);
  }

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  User? _user;
  bool _isInitializing = true;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get userId => _user?.uid;
  String? get email => _user?.email;
  bool get isLoggedIn => _user != null;
  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _onAuthChanged(User? user) {
    _user = user;
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(username: username, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendlyMessage(e);
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Coba lagi.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() => _authService.signOut();

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format username atau email tidak valid.';
      case 'user-disabled':
        return 'Akun ini sudah dinonaktifkan.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Username atau password salah.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      default:
        return 'Gagal masuk (${e.code}). Coba lagi.';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
} 