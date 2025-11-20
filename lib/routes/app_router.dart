import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Import Pages dan Notifier Anda
import 'package:aerion_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:aerion_dashboard/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/forgot_password_page.dart';
// import 'package:aerion_dashboard/features/cluster/presentation/pages/cluster_page.dart';
import 'package:aerion_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/profile_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/change_password_page.dart';
import 'package:aerion_dashboard/features/sites/presentation/pages/sites_page.dart';
import 'package:aerion_dashboard/features/alert/presentation/pages/alert_information_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/language_setting_page.dart';
import '../features/auth/presentation/providers/auth_notifier.dart'; // Asumsi lokasi AuthNotifier

// Params
import 'package:aerion_dashboard/features/onboarding/domain/entities/onboarding_item.dart';

import 'app_routes.dart';

// =============================================================================
// SHELL WRAPPER (Biasanya diletakkan di file terpisah, di sini untuk demo ShellRoute)
// Widget ini akan menahan BottomNavigationBar
// =============================================================================
class ShellWrapper extends StatelessWidget {
  final Widget child;
  const ShellWrapper({super.key, required this.child});

  // Helper untuk mendapatkan index rute dari list path
  int _getPageIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final routes = [
      AppRoutes.cluster,
      AppRoutes.sites,
      AppRoutes.dashboard,
      AppRoutes.alert,
    ];
    return routes.indexOf(location);
  }

  @override
  Widget build(BuildContext context) {
    // Daftar item navigasi
    final items = const [
      BottomNavigationBarItem(icon: Icon(Icons.hub), label: 'Cluster'),
      BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Sites'),
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alert'),
    ];

    return Scaffold(
      body:
          child, // Menampilkan halaman yang aktif (ClusterPage, SitesPage, dll)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getPageIndex(context) == -1 ? 0 : _getPageIndex(context),
        items: items,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          final routes = [
            AppRoutes.cluster,
            AppRoutes.sites,
            AppRoutes.dashboard,
            AppRoutes.alert,
          ];
          // Navigasi ke rute tanpa merusak state tab lain
          context.go(routes[index]);
        },
      ),
    );
  }
}

// =============================================================================
// GO ROUTER CONFIGURATION
// =============================================================================
class AppRouter {
  // Key untuk navigasi global (Full-screen pages, e.g., Login, Settings)
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // Key untuk ShellRoute (Bottom Navigation Bar)
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,

    // =========================================================================
    // IMPLEMENTASI REDIRECT/AUTH GUARD
    // =========================================================================
    redirect: (BuildContext context, GoRouterState state) {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final AuthState authState = authNotifier.state;

      final bool isCheckingAuth = authState.isCheckingAuth;
      final bool isLoggedIn = authState.user != null;
      final String goingTo = state.matchedLocation;

      // Menggunakan rute dari AppRoutes untuk menghindari error jika AppRoutes.root == '/'
      final bool isAuthPage =
          goingTo == AppRoutes.login || goingTo == AppRoutes.forgotPassword;

      if (isCheckingAuth) {
        // Jika masih loading, GoRouter akan menunggu. (Tergantung implementasi Splash Screen)
        return null;
      }

      // 1. SKENARIO: Sudah Login, tapi mencoba mengakses halaman Login/Auth.
      if (isLoggedIn && isAuthPage) {
        // Redirect ke halaman utama aplikasi yang memiliki Bottom Bar
        return AppRoutes.cluster;
      }

      // 2. SKENARIO: Belum Login, tapi mencoba mengakses halaman yang dilindungi.
      // Kita asumsikan semua halaman selain Login/Forgot adalah halaman yang dilindungi.
      // Karena kita menggunakan ShellRoute, rute yang dilindungi adalah rute Shell.
      final bool isProtectedPage = !isAuthPage;

      if (!isLoggedIn && isProtectedPage) {
        // Redirect kembali ke halaman Login
        return AppRoutes.login;
      }

      // 3. SKENARIO: Tidak perlu redirect (tetap di halaman yang dituju)
      return null;
    },

    // =========================================================================
    // DAFTAR RUTE
    // =========================================================================
    routes: [
      // -----------------------------------------------------------------------
      // 1. AUTH ROUTES (Full Screen / Root Navigator)
      // -----------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // -----------------------------------------------------------------------
      // 2. SHELL ROUTE: Container untuk Bottom Navigation Bar
      // -----------------------------------------------------------------------
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // 'child' adalah widget dari rute yang aktif (ClusterPage, SitesPage, dll)
          return ShellWrapper(child: child);
        },
        routes: [
          // ** TAB 1: CLUSTER **
          GoRoute(
            path: AppRoutes.cluster,
            builder: (context, state) => const OnboardingPage(),
            // Catatan: Jika OnboardingPage adalah halaman sekali lihat,
            // sebaiknya letakkan logic penampilannya di redirect atau di ClusterPage.
          ),

          // ** TAB 2: SITES **
          GoRoute(
            path: AppRoutes.sites,
            builder: (context, state) {
              // Parsing state.extra untuk data OnboardingItem
              final cluster = state.extra is Map<String, dynamic>
                  ? (state.extra as Map<String, dynamic>)['cluster']
                        as OnboardingItem?
                  : null;
              return SitesPage(cluster: cluster);
            },
            // Sub-route di bawah Sites (Contoh: edit-device-name)
            routes: [
              GoRoute(
                path: AppRoutes.editDeviceName, // Path: /sites/edit-device-name
                builder: (context, state) =>
                    const Placeholder(), // Ganti dengan halaman EditDeviceNamePage
              ),
            ],
          ),

          // ** TAB 3: DASHBOARD **
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
            // Sub-route di bawah Dashboard (Profile)
            routes: [
              GoRoute(
                // Path: /dashboard/profile
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),

          // ** TAB 4: ALERT **
          GoRoute(
            path: AppRoutes.alert,
            builder: (context, state) {
              // Parsing state.extra untuk data OnboardingItem
              final cluster = state.extra is Map<String, dynamic>
                  ? (state.extra as Map<String, dynamic>)['cluster']
                        as OnboardingItem?
                  : null;
              return AlertInformationPage(cluster: cluster);
            },
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // 3. FULL-SCREEN SETTINGS ROUTES (Root Navigator)
      // -----------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) =>
            const ProfilePage(), // Asumsi ProfilePage adalah entry point Setting atau Profile utama
        routes: [
          GoRoute(
            // Path: /settings/change-password
            path: AppRoutes.changePassword,
            builder: (context, state) => const ChangePasswordPage(),
          ),
          GoRoute(
            // Path: /settings/language-settings
            path: AppRoutes.languageSettings,
            builder: (context, state) => const LanguageSettingPage(),
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
