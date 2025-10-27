import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipes_page.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({super.key});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();

}

class _ViewAllPageState extends State<ViewAllPage> {
  String? hoveredLabel;
  String selectedLabel = 'View ALL';
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // 🖼️ Image principale
                  Image.asset(
                    'assets/images/oip.jpg',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Container(height: 300, color: Colors.black.withOpacity(0.0)),

                  // 🟩 SVG décoratifs
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
                        color: Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
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
                            onTap: () => setState(() => selectedLabel = 'View ALL'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 🔸 Liste des recettes
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    _buildRecipeCard(
                      image: 'assets/images/recette/amande.jpg',
                      title: 'Almond Oil Recipe',
                      skinType: 'Sensitive skin',
                    ),
                    _buildRecipeCard(
                      image: 'assets/images/recette/aloe_vera.jpg',
                      title: 'Aloe Vera Recipe',
                      skinType: 'Dry skin',
                    ),
                    _buildRecipeCard(
                      image: 'assets/images/recette/curcuma.jpg',
                      title: 'Turmeric Mask',
                      skinType: 'Oily skin',
                    ),
                    _buildRecipeCard(
                      image: 'assets/images/recette/riz.jpg',
                      title: 'Rice Face Pack',
                      skinType: 'Brightening skin',
                    ),
                    _buildRecipeCard(
                      image: 'assets/images/recette/argan.jpg',
                      title: 'Argan Oil Recipe',
                      skinType: 'Normal skin',
                    ),
                    _buildRecipeCard(
                      image: 'assets/images/recette/concombre.jpg',
                      title: 'Cucumber Gel',
                      skinType: 'Refreshing skin',
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

  // 🌿 Boutons de filtre
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

  // 🌿 Carte recette
  Widget _buildRecipeCard({
    required String image,
    required String title,
    required String skinType,
  }) {
    return Material(
      elevation: 4, // 🌿 élévation subtile comme dans ton image
      color: Colors.transparent,
      shadowColor: Colors.grey.withOpacity(0.1), // ombre douce naturelle
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),   // haut plat
          topRight: Radius.circular(0),  // haut plat
          bottomLeft: Radius.circular(0), // bas plat
          bottomRight: Radius.circular(0), // bas plat
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1DF), // ✅ fond vert clair
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10), // ✅ ombre douce
              blurRadius: 8, // flou subtil comme sur ton image
              offset: const Offset(0, 2), // ✅ ombre juste en dessous
            ),
          ],
        ),

      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1DF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 12, // même position qu'avant
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite; // ✅ inverse l’état
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.white, // ❤️ rouge sinon centre blanc
                    size: 20, // même taille que ton image
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3), // légère ombre comme dans ton exemple
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: GoogleFonts.itim(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🟩 Bouton légèrement plus haut
                      Expanded(
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(1, -6), // 🔼 déplace vers le haut de 4 pixels
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF515151),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                                elevation: 3,
                              ),
                              child: Text(
                                'View',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🟫 Texte à droite
                      SizedBox(
                        width: 120,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            skinType,
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.itim(
                              fontSize: 20,
                              color: Colors.grey.shade900,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        ));
  }

  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: const Color(0xFF8CA87D),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SvgPicture.asset('assets/images/icone-home.svg',
                width: 30, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            Column(mainAxisSize: MainAxisSize.min, children: [
              SvgPicture.asset('assets/images/icone-recette.svg',
                  width: 30, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              const SizedBox(height: 3),
              const Text("Recipes", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ]),
            const Icon(Icons.public, color: Colors.white70, size: 35),
            SvgPicture.asset('assets/images/icone-profil.svg',
                width: 30, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ]),
        ),
      ),
    );
  }
}