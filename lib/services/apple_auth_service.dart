import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> signInWithApple() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.example.beaute_naturelle', // ton clientId Apple
        redirectUri: Uri.parse(
          'https://example.com/callbacks/sign_in_with_apple', // ton redirectUri
        ),
      ),
    );

    final email = credential.email ?? 'no-email@apple.com';

    // Envoyer au backend
    final url = Uri.parse('http://10.0.2.2:8080/api/auth/apple-simulate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Token backend: ${data['access_token']}');
    } else {
      print('Erreur backend: ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur Apple Sign In: $e');
  }
}