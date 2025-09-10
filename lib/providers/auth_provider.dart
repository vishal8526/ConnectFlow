import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

enum UserRole { employee, admin }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  UserRole? _role;
  bool _initializing = true;

  AuthProvider(this._authService) {
    _authService.authStateChanges().listen((u) {
      _user = u;
      _initializing = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  UserRole? get role => _role;
  bool get initializing => _initializing;

  Future<void> signIn(String email, String password, UserRole selectedRole) async {
    await _authService.signInWithEmail(email: email, password: password);
    _role = selectedRole; // In real app, fetch role from Firestore users collection
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _role = null;
    notifyListeners();
  }
}


