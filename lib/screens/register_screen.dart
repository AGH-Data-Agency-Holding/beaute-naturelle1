import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String baseUrl = "http://10.0.2.2:8000/api/auth";

  // 🔹 Fonction Sign Up
  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await http.post(
          Uri.parse("$baseUrl/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Compte créé avec succès ✅"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Utilisateur déjà existant ❌"),
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

        // 🔹 Appeler backend ici
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

        // 🔹 Appeler backend ici
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
      {Color color = Colors.black87, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE5D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
                      const SizedBox(height: 120),

                      // Icône principale
                      const Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Color(0xFF5C715E),
                      ),
                      const SizedBox(height: 10),

                      // Titre
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Formulaire
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInputField(
                              icon: Icons.person_outline,
                              hint: 'Enter your Identification',
                              controller: _idController,
                            ),
                            const SizedBox(height: 15),
                            _buildInputField(
                              icon: Icons.email_outlined,
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                            ),
                            const SizedBox(height: 15),
                            _buildInputField(
                              icon: Icons.lock_outline,
                              hint: 'Enter your Password',
                              obscureText: true,
                              controller: _passwordController,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bouton Sign Up
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CA68C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Lien vers Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account ? ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "LOGIN",
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

                      // Boutons sociaux
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFF1877F2),
                            onTap: () => handleFacebookSignIn(context),
                          ),
                          const SizedBox(width: 20),
                          _socialButton(
                            FontAwesomeIcons.google,
                            color: Color(0xFF34A853),
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

  // 🔹 Champ Input
  Widget _buildInputField({
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '⚠️ Ce champ est obligatoire';
        }

        // Validation email simple
        if (hint.toLowerCase().contains('email')) {
          if (!value.contains('@') || !value.contains('.')) {
            return '❌ Veuillez entrer un email valide';
          }
        }

        // Validation mot de passe renforcée
        if (hint.toLowerCase().contains('password')) {
          final password = value;

          final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
          final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
          final hasDigit = RegExp(r'\d').hasMatch(password);
          final isLongEnough = password.length >= 8;

          if (!isLongEnough || !hasUppercase || !hasLowercase || !hasDigit) {
            return '''
🔐The password must contain:
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
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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