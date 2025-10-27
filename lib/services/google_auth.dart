import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

Future<Map<String, String>?> signInWithGoogle() async {
  try {
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // L'utilisateur a annulé
    final auth = await account.authentication;
    return {
      'accessToken': auth.accessToken ?? '',
      'idToken': auth.idToken ?? '',
      'email': account.email,
      'displayName': account.displayName ?? '',
      'photoUrl': account.photoUrl ?? '',
    };
  } catch (e) {
    print('Erreur Google Sign-In: $e');
    return null;
  }
}