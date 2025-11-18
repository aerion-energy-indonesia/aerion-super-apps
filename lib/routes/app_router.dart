import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // <<< Import Provider

// Import Pages dan Notifier Anda
import 'package:aerion_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:aerion_dashboard/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aerion_dashboard/features/cluster/presentation/pages/cluster_page.dart';
import 'package:aerion_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/profile_page.dart';
import '../features/auth/presentation/providers/auth_notifier.dart';
import 'app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,

    // =========================================================================
    // IMPLEMENTASI REDIRECT/AUTH GUARD
    // =========================================================================
    redirect: (BuildContext context, GoRouterState state) {
      // Akses AuthState dari Provider tanpa mendengarkan perubahannya
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final AuthState authState = authNotifier.state;

      // Ambil nilai dari AuthState
      final bool isCheckingAuth = authState.isCheckingAuth;
      final bool isLoggedIn = authState.user != null;

      // Path yang sedang dituju pengguna
      final String goingTo = state.matchedLocation;

      // Apakah pengguna mencoba mengakses halaman Login/Forgot Password?
      final bool isAuthPage =
          goingTo == AppRoutes.login || goingTo == AppRoutes.forgotPassword;

      if (isCheckingAuth) {
        // Jika masih loading, tetap di halaman yang dituju saat ini (atau tampilkan Splash/Loading screen)
        // Jika Anda memiliki halaman Loading/Splash screen, arahkan ke sana
        // Contoh: return AppRoutes.loading;
        return null; // Membiarkan GoRouter menunggu sambil menampilkan halaman saat ini (atau halaman yang diminta)
      }
      // 1. SKENARIO: Sudah Login, tapi mencoba mengakses halaman Login/Auth.
      if (isLoggedIn && isAuthPage) {
        // Redirect ke halaman utama (Onboarding atau Dashboard)
        // Kita gunakan Onboarding sebagai tujuan default setelah login
        return AppRoutes.onboarding;
      }

      // 2. SKENARIO: Belum Login, tapi mencoba mengakses halaman yang dilindungi.
      // Kita asumsikan semua halaman selain Login/Forgot adalah halaman yang dilindungi.
      if (!isLoggedIn && !isAuthPage) {
        // Redirect kembali ke halaman Login
        return AppRoutes.login;
      }

      // 3. SKENARIO: Tidak perlu redirect (tetap di halaman yang dituju)
      return null;
    },

    // =========================================================================
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

      // Rute Utama: Onboarding Page (Target setelah login)
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      GoRoute(
        path: AppRoutes.cluster,
        builder: (context, state) => const ClusterPage(),
      ),

      // Rute Utama: Dashboard Page
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            // Path menjadi '/dashboard/profile'
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],

    // Optional: Error/404 Page
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('404 - Halaman tidak ditemukan')),
    ),
  );
}
