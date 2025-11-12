// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import Pages dari fitur-fitur Anda (Presentation Layer)
// import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
// import '../features/auth/presentation/pages/user_profile_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // Kunci navigator utama
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard, // Rute awal
    // Konfigurasi semua rute dalam bentuk GoRoute
    routes: [
      // Rute Utama: Login Page
      // GoRoute(
      //   path: AppRoutes.login,
      //   builder: (context, state) => const LoginPage(),
      // ),

      // Rute Utama: Dashboard Page
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),

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
