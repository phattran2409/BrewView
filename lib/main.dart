import 'package:briewview/core/services/deep_link_handler.dart';
import 'package:briewview/core/services/deep_link_service.dart';
import 'package:briewview/features/auth/repository/auth_repository.dart';
import 'package:briewview/features/auth/repository/auth_repository_impl.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized successfully");
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "1126275602705437", // Replace with your Facebook App ID
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
    // Configure Firebase for better locale handling
    await _configureFirebase();
    print("✅ Firebase configured for locale");

    await configureDependencies();
    print("✅ Dependencies configured");

    // Debug DI registration
    print('=== DI Registration Debug ===');
    print('AuthBloc registered: ${getIt.isRegistered<AuthBloc>()}');
    print('AppRouter registered: ${getIt.isRegistered<AppRouter>()}');

    // ✅ Khởi tạo Deep Link Service
    final deepLinkService = getIt<DeepLinkService>();
    await deepLinkService.initialize();
    print("✅ DeepLinkService initialized");

    // ✅ Khởi tạo Deep Link Handler
    final deepLinkHandler = getIt<DeepLinkHandler>();
    deepLinkHandler.startListening();
    print("✅ DeepLinkHandler started");
  } catch (error) {
    print("❌ Initialization failed: $error");
  }

  runApp(const MyApp());
}

Future<void> _configureFirebase() async {
  // This ensures Firebase services use proper locale
  try {
    // Any additional Firebase configuration can go here
    print("🌐 Firebase locale coniguration cofmpleted");
  } catch (e) {
    print("⚠️ Firebase locale configuration warning: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ✅ Global AuthBloc
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
          lazy: false, // Create immediately
        ),
        
        // ✅ Global PremiumBloc
        BlocProvider<PremiumBloc>(
          create: (_) => getIt<PremiumBloc>(),
          lazy: false, // Create immediately
        ),
      ],
      child: MaterialApp.router(
        title: 'BrewView',
        routerConfig: getIt<AppRouter>().router,
        theme: ThemeData(primarySwatch: Colors.brown),
        // Fix Firebase locale warning
        locale: const Locale('en', 'US'),
        supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
        localizationsDelegates: const [
          // Material localization delegates will be added automatically
        ],
      ),
    );
  }
}
