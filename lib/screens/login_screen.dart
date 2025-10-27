// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// 🔹 Google Sign-In
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  static const String baseUrl = "http://10.0.2.2:8000/api/auth";

  // 🔹 Connexion classique
  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await http.post(
          Uri.parse("$baseUrl/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['access_token'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Connexion réussie ✅"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Identifiants invalides ❌"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur : ${response.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur réseau : $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 🔹 Demander réinitialisation mot de passe
  void _requestPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer un email valide"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password-request"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lien de réinitialisation envoyé ✅"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur : ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur réseau : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Connexion Facebook
  Future<void> handleFacebookSignIn(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData();
        print('Access Token: ${accessToken.token}');
        print('User Data: $userData');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connexion Facebook réussie : ${userData['email']}"),
            backgroundColor: Colors.green,
          ),
        );

      } else if (result.status == LoginStatus.cancelled) {
        print('Connexion Facebook annulée par l’utilisateur');
      } else {
        print('Erreur Facebook Login: ${result.message}');
      }
    } catch (error) {
      print('Erreur Facebook Sign-In: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur Facebook Sign-In: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Connexion Google
  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final auth = await account.authentication;
        print('Access Token: ${auth.accessToken}');
        print('ID Token: ${auth.idToken}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connexion Google réussie : ${account.email}"),
            backgroundColor: Colors.green,
          ),
        );

      }
    } catch (error) {
      print('Erreur Google Sign-In: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur Google Sign-In: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Bouton social
  Widget _socialButton(IconData icon,
      {Color iconColor = Colors.black87, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE5D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Image.asset(
                            'assets/logo2.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 140),

                      // Icône principale
                      const Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Color(0xFF5C715E),
                      ),
                      const SizedBox(height: 10),

                      // Titre
                      const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Formulaire
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInputField(
                              icon: Icons.email_outlined,
                              hint: 'Enter your email',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 15),
                            _buildInputField(
                              icon: Icons.lock_outline,
                              hint: 'Enter your Password',
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _requestPasswordReset, // 🔹 Appelle l'API
                          child: const Text(
                            "FORGOT PASSWORD?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bouton Sign In
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9CAF88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Lien Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New here ? ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // "Or continue with"
                      const Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Color(0xFF5C715E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Icônes sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔹 Facebook
                          _socialButton(
                            FontAwesomeIcons.facebookF,
                            iconColor: Color(0xFF1877F2),
                            onTap: () => handleFacebookSignIn(context),
                          ),
                          const SizedBox(width: 20),


                          // 🔹 Google
                          _socialButton(
                            FontAwesomeIcons.google,
                            iconColor: Color(0xFF34A853),
                            onTap: () => handleGoogleSignIn(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔹 Input Field
// 🔹 Champ d'entrée réutilisable pour Register avec validation renforcée
  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '⚠️ Ce champ est obligatoire';
        }

        // 🔸 Validation email
        if (hint.toLowerCase().contains('email')) {
          if (!value.contains('@') || !value.contains('.')) {
            return '❌ Veuillez entrer un email valide';
          }
        }

        // 🔸 Validation mot de passe renforcée pour register
        if (hint.toLowerCase().contains('password')) {
          final password = value;

          final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
          final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
          final hasDigit = RegExp(r'\d').hasMatch(password);
          final isLongEnough = password.length >= 8;

          if (!isLongEnough || !hasUppercase || !hasLowercase || !hasDigit) {
            return '''
🔐 The password must contain:
• At least 8 characters
• An uppercase letter
• A lowercase letter
• A number
''';
          }
        }

        return null; // ✅ Tout est bon
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5C715E), width: 1.5),
        ),
      ),
    );
  }
}