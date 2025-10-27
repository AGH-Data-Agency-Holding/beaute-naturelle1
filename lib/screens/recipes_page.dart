import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'view_all_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String hoveredNav = "";
  String? hoveredLabel;
  String selectedLabel = 'Allergy Type';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2EE),
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/photo-filles.jpg',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 210,
                    right: 320,
                    child: SvgPicture.asset(
                      'assets/vector-2.svg',
                      width: 55,
                      height: 40,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFDCE6D1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 230,
                    right: 350,
                    child: SvgPicture.asset(
                      'assets/vector-3.svg',
                      width: 30,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFDCE6D1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  // 🔹 Header avec menu et titre
                  Positioned(
                    top: 1,
                    left: 16,
                    right: 190,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 35),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Menu à venir...")),
                            );
                          },
                        ),
                        Text(
                          'Recipes',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // 🔍 Barre de recherche
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF515151),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.itim(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'Research by location',
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.itim(
                                  color: const Color(0xFF515151).withOpacity(0.8),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const Icon(Icons.search, color: Color(0xFF515151), size: 30),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 Dropdowns
                  Positioned(
                    top: 110,
                    left: 40,
                    right: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdown('Culture'),
                        _buildDropdown('Origine'),
                      ],
                    ),
                  ),

                  // 🔹 Boutons de filtre
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFilterButton(
                            'Skin Type',
                            onTap: () => setState(() => selectedLabel = 'Skin Type'),
                          ),
                          _buildFilterButton(
                            'Allergy Type',
                            onTap: () {
                              setState(() => selectedLabel = 'Allergy Type');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c) => const RecipesPage()),
                              );
                            },
                          ),
                          _buildFilterButton(
                            'View ALL',
                            onTap: () {
                              setState(() => selectedLabel = 'View ALL');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c) => const ViewAllPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  children: [
                    // 🌿 Image de fond
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset(
                        'assets/images/aloevera1.jpg',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 🌿 Cadre transparent autour du texte
                    Positioned.fill(
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.9, // ✅ cadre à 90 % de la largeur
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25), // transparence douce
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8), // bord blanc visible
                                width: 6,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'BEST',
                                  style: GoogleFonts.poppins(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  'natural remedies',
                                  style: GoogleFonts.itim(
                                    fontSize: 34,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 🌿 Barre verte en bas
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 8, // épaisseur de la barre
                        decoration: const BoxDecoration(
                          color: Color(0xFFE1EDD2), // ✅ vert naturel
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// 🌼 petit espace entre les deux sections
              const SizedBox(height: 4),

// 🌿 Défilement horizontal des cartes identiques
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                child: Row(
                  children: [
                    // 🔹 Première carte
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        width: 397, // ✅ même largeur compacte que ton exemple
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Atopic dermatitis',
                              style: GoogleFonts.poppins(
                                fontSize: 21, // ✅ même taille de texte que sur ton image
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4C4C4C),
                              ),
                            ),
                            const SizedBox(height: 0),
                            Text(
                              'Atopic eczema',
                              style: GoogleFonts.itim(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey.shade100,
                                child: Image.asset(
                                  'assets/images/aloevera2.jpg',
                                  width: double.infinity,
                                  height: 145, // ✅ correspond à la proportion de ton capture
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Deuxième carte
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: Container(
                        width: 397,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aloe soothing',
                              style: GoogleFonts.poppins(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4C4C4C),
                              ),
                            ),
                            const SizedBox(height: 0),
                            Text(
                              'Skin relief',
                              style: GoogleFonts.itim(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey.shade100,
                                child: Image.asset(
                                  'assets/images/aloevera2.jpg',
                                  width: double.infinity,
                                  height: 145,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Troisième carte
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 397,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Psoriasis relief',
                              style: GoogleFonts.poppins(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4C4C4C),
                              ),
                            ),
                            const SizedBox(height: 0),
                            Text(
                              'Natural remedy',
                              style: GoogleFonts.itim(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey.shade100,
                                child: Image.asset(
                                  'assets/images/aloevera2.jpg',
                                  width: double.infinity,
                                  height: 145,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),

    );
  }


  Widget _buildDropdown(String label) {
    return Container(
      width: 160,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.itim(
              color: const Color(0xFF515151),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF515151),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, {VoidCallback? onTap}) {
    final bool isSelected = selectedLabel == label;
    final bool isHovered = hoveredLabel == label;
    final bool active = isSelected || isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredLabel = label),
      onExit: (_) => setState(() => hoveredLabel = null),
      child: GestureDetector(
        onTap: () {
          setState(() => selectedLabel = label);
          if (onTap != null) onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.itim(
                fontSize: 18,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: active ? (_textWidth(label) + 8) : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _textWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: GoogleFonts.itim(fontSize: 18)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  Widget _buildRecipeCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 180, // ✅ largeur fixe pour le défilement horizontal
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF505050),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.itim(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: const Color(0xFF8CA87D),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // HOME (pas de texte sous icône)
              MouseRegion(
                onEnter: (_) => setState(() => hoveredNav = "Home"),
                onExit: (_) => setState(() => hoveredNav = ""),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/icone-home.svg',
                      width: 30,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    if (hoveredNav == "Home")
                      const SizedBox(height: 2),
                    if (hoveredNav == "Home")
                      const Text("Home", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              // RECIPES (texte toujours affiché)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/icone-recette.svg',
                    width: 30,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 2),
                  const Text("Recipes", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),

              // WORLD
              MouseRegion(
                onEnter: (_) => setState(() => hoveredNav = "World"),
                onExit: (_) => setState(() => hoveredNav = ""),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.public, color: Colors.white70, size: 35),
                    if (hoveredNav == "World")
                      const SizedBox(height: 2),
                    if (hoveredNav == "World")
                      const Text("World", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              // PROFILE
              MouseRegion(
                onEnter: (_) => setState(() => hoveredNav = "Profile"),
                onExit: (_) => setState(() => hoveredNav = ""),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/icone-profil.svg',
                      width: 30,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    if (hoveredNav == "Profile")
                      const SizedBox(height: 2),
                    if (hoveredNav == "Profile")
                      const Text("Profile", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

