import 'package:aerion_dashboard/features/cluster/presentation/pages/cluster_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/about_us_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/help_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/language_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Import Pages dan Notifier Anda
import 'package:aerion_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:aerion_dashboard/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/change_profile_page.dart';
import 'package:aerion_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:aerion_dashboard/features/profile/presentation/pages/profile_page.dart';
import 'package:aerion_dashboard/features/auth/presentation/pages/change_password_page.dart';
// import 'package:aerion_dashboard/features/sites/presentation/pages/sites_page.dart';
import 'package:aerion_dashboard/features/alert/presentation/pages/alert_information_page.dart';
import 'package:aerion_dashboard/features/analysis/presentation/pages/analysis_page.dart';
import 'package:aerion_dashboard/features/data/presentation/pages/data_page.dart';
import 'package:aerion_dashboard/features/activity/presentation/pages/activity_page.dart';
import '../features/auth/presentation/providers/auth_notifier.dart';

// Params
import 'package:aerion_dashboard/features/onboarding/domain/entities/onboarding_item.dart';

import 'app_routes.dart';

// =============================================================================
// HELPER WIDGET: SVG ICON BUILDER
// =============================================================================
class SvgBottomBarIcon extends StatelessWidget {
  final String assetPath;
  final Color color;
  final double size;

  const SvgBottomBarIcon({
    super.key,
    required this.assetPath,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    // SvgPicture.asset akan memuat file SVG lokal Anda
    return SvgPicture.asset(
      assetPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: size,
      height: size,
      // Placeholder jika file SVG tidak ditemukan
      placeholderBuilder: (BuildContext context) =>
          Icon(Icons.error, color: color),
    );
  }
}

// =============================================================================
// SHELL WRAPPER (Diperbarui untuk menggunakan SVG dan rute yang benar)
// =============================================================================
class ShellWrapper extends StatelessWidget {
  final Widget child;
  const ShellWrapper({super.key, required this.child});

  // Warna dan Konstanta
  static const Color activeIconColor = Color(0xFFE41E26); // Merah aktif
  static const Color inactiveIconColor = Color(
    0xFF364153,
  ); // Abu-abu gelap non-aktif

  // Daftar Item Navigasi Bawah (Dengan path SVG yang diasumsikan)
  final List<({String location, String asset, String label})> tabs = const [
    (
      location: AppRoutes.dashboard,
      asset: 'assets/svg/grid.svg',
      label: 'Monitor',
    ),
    (
      location: AppRoutes.activity,
      asset: 'assets/svg/activity.svg',
      label: 'Graphic',
    ),
    (
      location: AppRoutes.analysis,
      asset: 'assets/svg/pie-chart.svg',
      label: 'Analysis',
    ),
    (location: AppRoutes.data, asset: 'assets/svg/file.svg', label: 'Data'),
    (
      location: AppRoutes.alert,
      asset: 'assets/svg/alert-triangle.svg',
      label: 'Alert',
    ), // Mengubah label
  ];

  // Mendapatkan indeks tab yang aktif berdasarkan lokasi saat ini
  int _getPageIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final routes = [
      AppRoutes.dashboard,
      AppRoutes.activity,
      AppRoutes.analysis,
      AppRoutes.data,
      AppRoutes.alert,
    ];

    // Temukan index rute utama yang cocok dengan awal lokasi saat ini
    final index = routes.indexWhere(
      (routePath) => location.startsWith(routePath),
    );

    return index == -1 ? 0 : index; // Default ke Cluster
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getPageIndex(context);

    return Scaffold(
      body: child, // Menampilkan halaman anak (ClusterPage, SitesPage, dll)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return BottomNavigationBarItem(
            icon: SvgBottomBarIcon(
              assetPath: tab.asset,
              color: isSelected
                  ? activeIconColor
                  : inactiveIconColor.withOpacity(0.6),
            ),
            label: tab.label,
          );
        }).toList(),

        type: BottomNavigationBarType.fixed,
        selectedItemColor: activeIconColor,
        unselectedItemColor: inactiveIconColor.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 11,
        ),
        backgroundColor: Colors.white,
        elevation: 8,

        onTap: (index) {
          // Navigasi ke rute utama ShellRoute
          context.go(tabs[index].location);
        },
      ),
    );
  }
}

// =============================================================================
// GO ROUTER CONFIGURATION
// =============================================================================
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
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

      final bool isAuthPage =
          goingTo == AppRoutes.login || goingTo == AppRoutes.forgotPassword;

      if (isCheckingAuth) {
        return null;
      }

      if (isLoggedIn && isAuthPage) {
        // Redirect ke halaman Cluster setelah login sukses
        return AppRoutes.cluster;
      }

      final bool isProtectedPage = !isAuthPage;

      if (!isLoggedIn && isProtectedPage) {
        return AppRoutes.login;
      }

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

      // Rute Onboarding (Diasumsikan ini adalah halaman splash atau intro)
      GoRoute(
        path: AppRoutes.cluster,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Rute Edit Device Name (Diletakkan di Root karena biasanya full screen)
      GoRoute(
        path:
            '/${AppRoutes.editDeviceName}', // Perlu slash di depan karena di root
        builder: (context, state) =>
            const Placeholder(), // Ganti dengan EditDeviceNamePage
      ),

      // -----------------------------------------------------------------------
      // 2. SHELL ROUTE: Container untuk Bottom Navigation Bar
      // -----------------------------------------------------------------------
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ShellWrapper(child: child);
        },
        routes: [
          // ** TAB 1: CLUSTER **
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),

          GoRoute(
            path: AppRoutes.activity,
            builder: (context, state) => const ActivityPage(),
          ),
          GoRoute(
            path: AppRoutes.analysis,
            builder: (context, state) => const AnalysisPage(),
          ),
          GoRoute(
            path: AppRoutes.data,
            builder: (context, state) => const DataDetailsPage(),
          ),

          // ** TAB 2: SITES **
          // GoRoute(
          //   path: AppRoutes.sites,
          //   builder: (context, state) {
          //     final cluster = state.extra is OnboardingItem
          //         ? state.extra as OnboardingItem
          //         : null;
          //     // Catatan: SitesPage menggunakan 'cluster' di constructor.
          //     return SitesPage(cluster: cluster);
          //   },
          // ),

          // ** TAB 3: DASHBOARD **
          // GoRoute(
          //   path: AppRoutes.dashboard,
          //   builder: (context, state) => const DashboardPage(),
          //   // Sub-route di bawah Dashboard
          //   routes: [
          //     GoRoute(
          //       // Path: /dashboard/profile
          //       path: AppRoutes.profile,
          //       builder: (context, state) => const ProfilePage(),
          //     ),
          //   ],
          // ),

          // ** TAB 4: ALERT **
          GoRoute(
            path: AppRoutes.alert,
            builder: (context, state) {
              final cluster = state.extra is OnboardingItem
                  ? state.extra as OnboardingItem
                  : null;
              return AlertInformationPage(cluster: cluster);
            },
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // 3. FULL-SCREEN SETTINGS ROUTES (Root Navigator - Di luar Shell)
      // -----------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.settings,
        // Entry point untuk Settings
        builder: (context, state) => const ProfilePage(),
        routes: [
          // Change Profile Page
          GoRoute(
            // Navigasi di root navigator (Full screen)
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.changeProfile,
            builder: (context, state) => const EditProfilePage(),
          ),
          // Change Cluster Page
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.changeCluster,
            builder: (context, state) => const ClusterPage(),
          ),
          // Change Password Page
          GoRoute(
            // Navigasi di root navigator (Full screen)
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.changePassword,
            builder: (context, state) => const ChangePasswordPage(),
          ),
          // Change Password Page
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.changePassword,
            builder: (context, state) => const ChangePasswordPage(),
          ),
          // Language Settings Page
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.languageSettings,
            builder: (context, state) => const LanguageSettingPage(),
          ),
          // About Us Page
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.aboutUs,
            builder: (context, state) => const AboutUsPage(),
          ),
          // Help Page
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.help,
            builder: (context, state) => const HelpPage(),
          ), // Ganti  dengan HelpPage
        ],
      ),
    ],

    // Optional: Error/404 Page
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('404 - Halaman tidak ditemukan')),
    ),
  );
}
