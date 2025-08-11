import 'package:flutter/material.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/router/app_router.dart';
import 'package:briewview/app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrewView',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: getIt<AppRouter>().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
