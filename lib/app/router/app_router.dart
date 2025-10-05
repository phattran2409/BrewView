import 'package:briewview/features/auth/view/otp_page.dart';
import 'package:briewview/features/cafe/view/cafes_detail.dart';
import 'package:briewview/features/home/view/home_page.dart';
import 'package:briewview/features/post/view/post_detail.dart';
import 'package:briewview/features/post/view/post_list_page.dart';
import 'package:briewview/features/profile/view/edit_profile_page.dart';
import 'package:briewview/features/search/view/search_page.dart';
import 'package:briewview/features/profile/view/profile_page.dart';
import 'package:briewview/features/splash/view/splash_page.dart';
import 'package:briewview/features/survey/view/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/app/router/route_paths.dart';
import 'package:briewview/features/onboarding/view/onboarding_page.dart';
import 'package:briewview/features/auth/view/auth_login_pages.dart';
import 'package:briewview/features/auth/view/auth_resetpassword_pages.dart';
import 'package:briewview/features/cafe/view/review_list_page.dart';
import 'package:briewview/features/my_cafe/view/my_cafes_list_page.dart';
import 'package:briewview/features/my_cafe/view/my_cafe_form_page.dart';
import 'package:briewview/features/my_cafe/view/my_cafe_detail_page.dart';

// import 'package:briewview/features/user_management/view/user_list_page.dart';

@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: RoutePaths.splash,
      routes: [
        GoRoute(
          path: RoutePaths.splash,
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
          builder: (context, state) => const AuthLoginPage(),
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
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: RoutePaths.search,
          name: 'search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: RoutePaths.coffeeDetail,
          name: 'cafe-detail',
          builder: (context, state) {
            final cafeId = state.pathParameters['id'];
            return CafeDetail(cafeId: cafeId);
          },
        ),
        GoRoute(
          path: RoutePaths.cafeReviews,
          name: 'cafe-reviews',
          builder: (context, state) {
            final cafeId = state.pathParameters['id'] ?? '';
            return ReviewListPage(cafeId: cafeId);
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
        GoRoute(
          path: RoutePaths.profileEdit,
          name: 'profile-edit',
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: RoutePaths.resetPassword,
          name: 'reset-password',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return AuthResetPasswordPage(email: email);
          },
        ),
        GoRoute(
          path: RoutePaths.survey,
          name: 'survey',
          builder: (context, state) => const SurveyPage(),
        ),

        GoRoute(path: RoutePaths.postList, 
        name: 'post-list', 
        builder: (context, state) => const PostListPage()),

        GoRoute(
          path: RoutePaths.postDetail,
          name: 'post-detail',
          builder: (context, state) {
            final postId = state.pathParameters['id'];
            return PostDetailPage(postId: postId);
          },
        ),

      GoRoute(
          path: RoutePaths.myCafes,
          name: 'my-cafes',
          builder: (context, state) => const MyCafesListPage()),
        // GoRoute(
        //   path: RoutePaths.myCafeDetail,
        //   name: 'my-cafe-detail',
        //   builder: (context, state) {
        //     final cafeId = state.pathParameters['id']!;
        //     return MyCafeDetailPage(cafeId: cafeId);
        //   },
        // ),
        GoRoute(
          path: RoutePaths.myCafeCreate,
          name: 'my-cafe-create',
          builder: (context, state) => const MyCafeFormPage(),
        ),
        // GoRoute(
        //   path: RoutePaths.myCafeEdit,
        //   name: 'my-cafe-edit',
        //   builder: (context, state) {
        //     final cafeId = state.pathParameters['id']!;
        //     return MyCafeFormPage(cafeId: cafeId);
        //   },
        // ),
      ],
    );
  }
}

     
