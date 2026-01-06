import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuth = prefs.getBool('isAuthenticated') ?? false;
    if (isAuth) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> _saveAuthState(bool authenticated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', authenticated);
  }

  Future<bool> login({
    String? username,
    String? password,
    String? email,
  }) async {
    try {
      final response = await ApiService.login(
        username: username,
        password: password,
        email: email,
      );

      _currentUser = response['user'];
      _isAuthenticated = true;
      await _saveAuthState(true);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signup({
    required String username,
    required String password,
    String? email,
  }) async {
    try {
      final response = await ApiService.signup(
        username: username,
        password: password,
        email: email,
      );

      _currentUser = response['user'];
      _isAuthenticated = true;
      await _saveAuthState(true);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    await _saveAuthState(false);
    notifyListeners();
  }
}

