import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';

class FacialScanIntroScreen extends StatefulWidget {
  final File? imageFile; // 👈 Image reçue depuis FacialScanScreen

  const FacialScanIntroScreen({super.key, this.imageFile});

  @override
  State<FacialScanIntroScreen> createState() => _FacialScanIntroScreenState();
}

class _FacialScanIntroScreenState extends State<FacialScanIntroScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // ✅ Récupère directement l’image envoyée depuis FacialScanScreen
    _image = widget.imageFile;
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFFDDE9CD); // Vert clair
    final Color buttonColor = const Color(0xFF8BA683); // Vert doux

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Logo en haut à gauche
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/logo.png',
                  height: 60,
                ),
              ),

              const Spacer(),

              // Cercle central avec l’image reçue
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 95,
                  backgroundColor: mainColor.withOpacity(0.4),
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                    Icons.person,
                    size: 100,
                    color: mainColor,
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Texte sous le cercle
              Column(
                children: [
                  Text(
                    "TAKE A PICTURE NOW",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "AI TELLS YOU  WHAT\nYOUR SKIN NEEDS",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Trois petits boutons gris
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _roundIconButton(Icons.camera_alt, _pickImageFromCamera),
                  const SizedBox(width: 20),
                  _roundIconButton(Icons.add, _pickImageFromGallery),
                  const SizedBox(width: 20),
                  _roundIconButton(Icons.edit, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Edit feature coming soon")),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 130),

              // Boutons "Get started" et "Back"
              Column(
                children: [
                  _buildButton(
                    "Get started",
                    buttonColor,
                    Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(), // ← redirige vers LoginScreen
                        ),
                      );

                    },
                  ),
                  const SizedBox(height: 10),
                  _buildButton(
                    "Back",
                    buttonColor,
                    Colors.white,
                        () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // Petit bouton rond icône
  Widget _roundIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Icon(icon, color: Colors.white, size: 25),
      ),
    );
  }

  // Boutons principaux
  Widget _buildButton(String text, Color bg, Color fg, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        minimumSize: const Size(180, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}