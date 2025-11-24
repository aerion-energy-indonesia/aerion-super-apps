import 'package:aerion_dashboard/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart'; // <<< PENTING: Import untuk SVG

// =========================================================================
// HELPER WIDGET: SVG ICON BUILDER
// =========================================================================
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
      // Menggunakan ColorFilter.mode untuk mewarnai SVG (seperti mengubah IconData)
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: size,
      height: size,
      // Placeholder jika file SVG tidak ditemukan di folder aset
      placeholderBuilder: (BuildContext context) =>
          Icon(Icons.error, color: color),
    );
  }
}

class MainScaffold extends StatelessWidget {
  // Widget yang akan ditampilkan di tengah Scaffold (halaman yang aktif)
  final Widget child;

  const MainScaffold({super.key, required this.child});

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color activeIconColor = Color(
    0xFFE41E26,
  ); // Menggunakan warna merah sesuai Bottom Bar di SitesPage
  static const Color inactiveIconColor = Color(0xFF364153);

  // =========================================================================
  // Daftar Item Navigasi Bawah (Diperbarui dengan path SVG)
  // PASTIKAN PATH SVG INI ADA DI FOLDER ASET ANDA!
  // =========================================================================
  final List<({String location, String asset, String label})> tabs = const [
    (
      location: AppRoutes.cluster,
      asset: 'assets/svg/cluster.svg',
      label: 'Cluster',
    ),
    (location: AppRoutes.sites, asset: 'assets/svg/sites.svg', label: 'Sites'),
    (
      location: AppRoutes.dashboard,
      asset: 'assets/svg/dashboard.svg',
      label: 'Dashboard',
    ),
    (location: AppRoutes.alert, asset: 'assets/svg/alert.svg', label: 'Alert'),
  ];

  // Mendapatkan indeks tab yang aktif berdasarkan lokasi saat ini
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final String location =
        router.routeInformationProvider.value.location ?? '';

    // Logika untuk mencocokkan lokasi.
    // Kita mencocokkan rute utama ShellRoute
    final routes = [
      AppRoutes.cluster,
      AppRoutes.sites,
      AppRoutes.dashboard,
      AppRoutes.alert,
    ];

    // Temukan index rute yang aktif
    final index = routes.indexWhere(
      (routePath) => location.startsWith(routePath),
    );

    // Jika berada di sub-rute /dashboard/profile, kembalikan index yang sesuai
    if (location.contains('/${AppRoutes.dashboard}/${AppRoutes.profile}')) {
      return routes.indexOf(AppRoutes.dashboard);
    }

    return index == -1 ? 0 : index;
  }

  // Menangani ketika tab ditekan
  void _onItemTapped(BuildContext context, int index) {
    if (index < tabs.length) {
      final String location = tabs[index].location;

      // Navigasi ke rute utama yang sesuai
      context.go(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan indeks tab yang aktif
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      // Tampilkan halaman anak (child) di body
      body: child,

      // =========================================================================
      // BOTTOM NAVIGATION BAR
      // =========================================================================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Pastikan semua label terlihat
        currentIndex: selectedIndex,
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
        onTap: (index) => _onItemTapped(context, index),

        items: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return BottomNavigationBarItem(
            // MENGGANTI Icon(tab.icon) dengan SvgBottomBarIcon
            icon: SvgBottomBarIcon(
              assetPath: tab.asset,
              color: isSelected
                  ? activeIconColor
                  : inactiveIconColor.withOpacity(0.6),
            ),
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }
}
