import 'package:briewview/app/di/locator.dart';
import 'package:briewview/features/auth/view/otp_page.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/cafe/view/cafes_detail.dart';
import 'package:briewview/features/home/view/home_page_demo.dart';
import 'package:briewview/features/search/widgets/search_page.dart';
import 'package:briewview/features/profile/view/profile_page.dart';
import 'package:briewview/features/splash/view/splash_page.dart';
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
      initialLocation: RoutePaths.splash,
      routes: [
        GoRoute(path: RoutePaths.splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),  
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
        ),
        GoRoute(
          path: RoutePaths.search,
          name: 'search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: RoutePaths.coffeeDetail,
          name: 'coffee-detail',
          builder: (context, state) {
            final coffeeId = state.pathParameters['id'];
            final coffeeData = state.extra as Map<String, dynamic>?;
            return CafeDetail(coffeeId: coffeeId, coffeeData: coffeeData);
          },
        ),
        GoRoute(
          path: RoutePaths.otp,
          name: 'otp',
          builder: (context, state) {
            final uid = state.pathParameters['id'];
            final email = state.extra as String?;
            return OtpPage(uid: uid, email: email);
          },
        ),
        GoRoute(
          path: RoutePaths.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(path: '/reset', 
          name: 'password-reset',
          builder: (context, state) {
            final token = state.uri.queryParameters['token'] ?? '';
            return Scaffold(
              appBar: AppBar(title: const Text('Reset Password')),
              body: Center(child: Text('Reset token: $token')),
            );
          }
        ),
      ],
    );
  }
}
