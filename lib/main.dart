import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/router/app_router.dart';
import 'package:briewview/app/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized successfully");

    await configureDependencies();
    print("✅ Dependencies configured");

    // Debug DI registration
    print('=== DI Registration Debug ===');
    print('AuthBloc registered: ${getIt.isRegistered<AuthBloc>()}');
    print('AppRouter registered: ${getIt.isRegistered<AppRouter>()}');
  } catch (error) {
    print("❌ Initialization failed: $error");
  }
  // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrewView',
      routerConfig: getIt<AppRouter>().router,
      theme: ThemeData(primarySwatch: Colors.brown),
    );
  }
}
