import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 4));
      final userStorage = getIt<UserStorageServices>();
      final token = getIt<TokenStorage>();

      final saveUser = await userStorage.getCurrentUser();
      final accessToken = await token.getAccess();
      if (mounted) {
        if (saveUser != null && accessToken != null) {
          context.go('/home');
          return;
        } else {
          final hasSeenOnBoarding = await _hasSeenOnboarding();
          if (hasSeenOnBoarding) {
            context.go('/login');
          } else {
            context.go('/onboarding');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  // Future<void> _navigateToNext() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   if (!mounted) return;
  //   Navigator.of(context).pushReplacementNamed('/onboarding');
  // }
  Future<bool> _hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF763C0C), // Your app's primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.coffee,
                size: 60,
                color: Color(0xFF763C0C),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ App Name
            const Text(
              'BrewView',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discover Amazing Coffee',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 48),

            // ✅ Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
