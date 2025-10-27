import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  // 🔹 Connexion
  Future<void> login(String email, String password) async {
    try {
      final data = await _authService.login(email, password);
      _token = data["token"];
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _token!);
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      rethrow; // permet d’afficher l’erreur dans l’écran login
    }
  }

  // 🔹 Inscription
  Future<void> register(String email, String password) async {
    await _authService.register(email, password);
  }

  // 🔹 Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // 🔹 Charger le token au démarrage
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    _isAuthenticated = _token != null;
    notifyListeners();
  }
}