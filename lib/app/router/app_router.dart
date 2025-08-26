import 'package:briewview/app/di/locator.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/home/view/home_page_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/app/router/route_paths.dart';
import 'package:briewview/features/onboarding/view/onboarding_page.dart';
import 'package:briewview/features/auth/view/auth_login_pages.dart';
// import 'package:briewview/features/user_management/view/user_list_page.dart';

@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: RoutePaths.onboarding,
      routes: [
        GoRoute(
          path: RoutePaths.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          name: 'login',
          builder:
              (context, state) => BlocProvider<AuthBloc>(
                create: (context) => getIt<AuthBloc>(),
                child: const AuthLoginPage(),
              ),
        ),
        GoRoute(
          path: RoutePaths.userList,
          name: 'user-list',
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('User List Page - Coming Soon!')),
              ),
        ),
        GoRoute(
          path: RoutePaths.home,
          name: 'home',
          builder: (context, state) => const HomePageDemo(),
        )
      ],
    );
  }
}
