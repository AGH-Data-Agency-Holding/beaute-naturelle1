import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/splash_screen.dart';


void main() {
  runApp(const BeauteNaturelleApp());
}

class BeauteNaturelleApp extends StatelessWidget {
  const BeauteNaturelleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..loadToken(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beauté Naturelle',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),


        home: const SplashScreen(),

        // ✅ Routes nommées
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
      
        },
      ),
    );
  }
}
