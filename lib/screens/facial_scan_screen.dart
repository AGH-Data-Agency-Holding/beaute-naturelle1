import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'facial_scan_intro_screen.dart';
import 'edit_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class FacialScanScreen extends StatefulWidget {
  const FacialScanScreen({super.key});

  @override
  State<FacialScanScreen> createState() => _FacialScanScreenState();
}

class _FacialScanScreenState extends State<FacialScanScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
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

              // Cercle central (photo ou bouton +)
              GestureDetector(
                onTap: _pickImageFromCamera,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: mainColor,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.add, size: 60, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "START YOUR FACIAL SCAN",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 60),

              // Trois petits boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _roundIconButton(Icons.camera_alt, _pickImageFromCamera),
                  const SizedBox(width: 20),
                  _roundIconButton(Icons.add, _pickImageFromGallery),
                  const SizedBox(width: 20),
                  // 🚀 Modifier ici pour ouvrir EditImageScreen
                  _roundIconButton(Icons.edit, () {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please take or choose a photo first")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditImageScreen(
                          initialImage: _image!,
                          onImageEdited: (editedImage) {
                            setState(() {
                              _image = editedImage;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 130),

              // Boutons "Saved" et "Back"
              Column(
                children: [
                  _buildButton("Saved", buttonColor, Colors.white, () {
                    if (_image != null) {
                      // ✅ Envoie la photo à FacialScanIntroScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FacialScanIntroScreen(imageFile: _image!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please take or choose a photo first")),
                      );
                    }
                  }),
                  const SizedBox(height: 10),
                  _buildButton("Back", buttonColor, Colors.white, () {
                    Navigator.pop(context);
                  }),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // Bouton rond icône
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

  // Bouton principal
  Widget _buildButton(String text, Color bg, Color fg, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        minimumSize: const Size(150, 45),
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