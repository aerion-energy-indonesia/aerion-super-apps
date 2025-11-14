// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import Pages dari fitur-fitur Anda (Presentation Layer)
import 'package:aerion_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:aerion_dashboard/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/forgot_password_page.dart';
// import '../features/auth/presentation/pages/user_profile_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // Kunci navigator utama
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login, // Rute awal
    // Konfigurasi semua rute dalam bentuk GoRoute
    routes: [
      // Rute Utama: Login Page
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Rute Utama: onboarding Page
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),

        // Contoh Sub-route (child route)
        routes: [
          // GoRoute(
          //   // Path menjadi '/dashboard/profile'
          //   path: AppRoutes.profile,
          //   builder: (context, state) => const UserProfilePage(),
          // ),
        ],
      ),
    ],

    // Optional: Error/404 Page
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('404 - Halaman tidak ditemukan')),
    ),
  );
}
