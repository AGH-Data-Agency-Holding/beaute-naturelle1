import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _leafController;
  late AnimationController _petalController;
  List<Color> _colors = [Colors.white, Color(0xFFE8F5E9)];

  final int _petalCount = 8;
  final Random _random = Random();
  late List<Offset> _petalPositions;
  late List<double> _petalSizes;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scaleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack);

    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // ⚡ Initialisation immédiate pour éviter le LateInitializationError
    final width = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    final height = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

    _petalPositions = List.generate(
      _petalCount,
          (index) => Offset(
        _random.nextDouble() * width,
        _random.nextDouble() * height,
      ),
    );
    _petalSizes =
        List.generate(_petalCount, (index) => 8.0 + _random.nextDouble() * 10);

    _fadeController.forward();
    _scaleController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _leafController.dispose();
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leafOffset = Tween(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOut),
    );

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 5),
        onEnd: () {
          setState(() {
            _colors = _colors[0] == Colors.white
                ? [Colors.white, Colors.green.shade100]
                : [Colors.white, Color(0xFFE8F5E9)];
          });
        },
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 🌿 Feuilles haut gauche
              Positioned(
                top: 40,
                left: 15,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(leafOffset.value, 0),
                      child: child,
                    );
                  },
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
              ),
              Positioned(
                top: 20,
                left: 75,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(-leafOffset.value, 0),
                      child: child,
                    );
                  },
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
              ),

              // 🌿 Feuilles centre droite
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 100,
                right: 40,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, leafOffset.value / 2),
                      child: child,
                    );
                  },
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
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 150,
                right: 85,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, leafOffset.value / 2),
                      child: child,
                    );
                  },
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
              ),

              // 🌿 Feuilles bas droite
              Positioned(
                bottom: 80,
                right: 20,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -leafOffset.value / 2),
                      child: child,
                    );
                  },
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
              ),
              Positioned(
                bottom: 35,
                right: 55,
                child: AnimatedBuilder(
                  animation: leafOffset,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -leafOffset.value / 2),
                      child: child,
                    );
                  },
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
              ),

              // 🌸 Pétales animés
              AnimatedBuilder(
                animation: _petalController,
                builder: (context, child) {
                  return Stack(
                    children: List.generate(_petalCount, (index) {
                      double top = (_petalPositions[index].dy +
                          50 * _petalController.value) %
                          MediaQuery.of(context).size.height;
                      double left = _petalPositions[index].dx +
                          20 * sin(2 * pi * _petalController.value);
                      return Positioned(
                        top: top,
                        left: left,
                        child: Icon(
                          Icons.star,
                          color: Colors.pink.shade100,
                          size: _petalSizes[index],
                        ),
                      );
                    }),
                  );
                },
              ),

              // Logo + texte + loader
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', height: 120)
                            .animate()
                            .fadeIn(duration: 1.seconds),
                        const SizedBox(height: 20),
                        Text(
                          "Bienvenue dans Beauté Naturelle 🌸",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ).animate().fadeIn(duration: 1.seconds, delay: 500.ms),
                        const SizedBox(height: 30),
                        const SizedBox(
                          height: 35,
                          width: 35,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF81C784),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}