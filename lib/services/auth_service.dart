import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  // ✅ Mets ici l’adresse réelle de ton backend FastAPI
  static const String baseUrl = "http://10.0.2.2:8080/api/auth";

  // 🔹 Inscription
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur d'inscription : ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion au serveur : $e");
    }
  }

  // 🔹 Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Exemple : {"access_token": "xxx", "token_type": "bearer"}
        return data;
      } else {
        throw Exception("Erreur de connexion : ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur réseau : $e");
    }
  }

  // 🔹 Sign In avec Apple
  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.beaute_naturelle', // ton clientId Apple
          redirectUri: Uri.parse(
            'https://example.com/callbacks/sign_in_with_apple',
          ),
        ),
      );

      final email = credential.email ?? 'no-email@apple.com';

      // Envoyer au backend
      final url = Uri.parse("$baseUrl/apple-simulate");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // contient le token backend
      } else {
        throw Exception("Erreur backend : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur Apple Sign In : $e");
    }
  }
}