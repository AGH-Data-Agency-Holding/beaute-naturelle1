import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  // 🔹 Connexion Facebook
  static Future<void> signIn(BuildContext context) async {
    try {
      // Demande des permissions
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print("Facebook Token: ${accessToken.token}");

        // Récupération des données utilisateur
        final userData =
        await FacebookAuth.instance.getUserData(fields: "name,email,picture");
        print("Facebook user data: $userData");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connexion Facebook réussie : ${userData['email']}"),
            backgroundColor: Colors.green,
          ),
        );

        // 🔹 Ici, tu peux appeler ton backend pour créer/utiliser l’utilisateur
      } else {
        print("Facebook login failed: ${result.status}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Facebook login échoué"),
            backgroundColor: Colors.red,
          ),
        );
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

  // 🔹 Déconnexion
  static Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    print("Facebook user disconnected");
  }
}