import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'facial_scan_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Color titleColor = Colors.grey.shade900;   // pour WELCOME
final Color subtitleColor = Colors.grey.shade600; // pour le sous-titre

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Couleurs personnalisées
    final Color titleColor = Colors.black87;
    final Color subtitleColor = Colors.black54;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🌿 Décorations coins haut et bas (ajoutées ici)
            // Feuilles haut gauche
              Positioned(
                top: 40,
                left: 15,
                child: SvgPicture.asset(
                  'assets/vector-3.svg',
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFDCE6D1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 75,
                child: SvgPicture.asset(
                  'assets/vector-2.svg',
                  width: 45,
                  height: 45,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFDCE6D1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 100, // centre verticalement
                  right:40,
                  child: SvgPicture.asset(
                    'assets/vector-4.svg',
                    width: 55,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFDCE6D1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 150, // légèrement décalé
                  right: 85,
                  child: SvgPicture.asset(
                    'assets/vector-5.svg',
                    width: 45,
                    height: 45,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFDCE6D1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),


  // Feuilles bas droite
            Positioned(
              bottom : 80,
              right: 20,
              child: SvgPicture.asset(
                'assets/vector.svg',
                width: 55,
                height: 25,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFDCE6D1),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              bottom: 35,
              right: 55,
              child: SvgPicture.asset(
                'assets/vector-1.svg',
                width: 45,
                height: 45,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFDCE6D1),
                  BlendMode.srcIn,
                ),
              ),
            ),


            // 🌸 Contenu principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo2.png',
                    height: 180,
                  ),
                  const SizedBox(height: 30),

                  // -- Titre WELCOME --
                  Text(
                    'WELCOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'FredokaOne', // utilise le .ttf que tu as ajouté
                      fontSize: 38,
                      color: Colors.grey.shade700, // plus foncé, fonctionne sans const
                      letterSpacing: 1.2,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // -- Sous-titre --
                  Text(
                    'Your skin, Your secret to glow',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                      letterSpacing: 0.15,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 180),

                  // Bouton Login
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9BAE8E), // vert doux
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Bouton Get Started
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FacialScanScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌿 Widget décoratif (feuille)
  Widget _leafIcon({double rotation = 0}) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        Icons.spa,
        color: Colors.green.shade100,
        size: 40,
      ),
    );
  }
}