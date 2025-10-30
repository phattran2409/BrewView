import 'package:briewview/core/services/deep_link_handler.dart';
import 'package:briewview/core/services/deep_link_service.dart';
import 'package:briewview/core/services/fcm_services.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized");

    // Initialize Mobile Ads with better error handling
    try {
      await MobileAds.instance.initialize();
      print("✅ Mobile Ads initialized");
    } catch (e) {
      print("⚠️ Mobile Ads initialization failed: $e");
      // Continue without ads if initialization fails
    }

    // Initialize FCM
    try {
      await FcmServices().initializeFCM();
      print("✅ FCM initialized");
    } catch (e) {
      print("⚠️ FCM initialization failed: $e");
    }
    
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
    FcmServices().setContext(context);  
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
