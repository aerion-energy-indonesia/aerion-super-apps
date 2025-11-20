import 'package:aerion_dashboard/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  // Widget yang akan ditampilkan di tengah Scaffold (halaman yang aktif)
  final Widget child;

  const MainScaffold({super.key, required this.child});

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color activeIconColor = Color(0xFF00305E);

  // Daftar Item Navigasi Bawah
  final List<({String location, IconData icon, String label})> tabs = const [
    (location: AppRoutes.cluster, icon: Icons.network_cell, label: 'Cluster'),
    (location: AppRoutes.sites, icon: Icons.location_on, label: 'Sites'),
    (location: AppRoutes.dashboard, icon: Icons.dashboard, label: 'Dashboard'),
    (
      location: AppRoutes.profile,
      icon: Icons.person,
      label: 'Account',
    ), // Nested route
  ];

  // Mendapatkan indeks tab yang aktif berdasarkan lokasi saat ini
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final String location =
        router.routeInformationProvider.value.location ?? '';

    // Logika untuk mencocokkan lokasi.
    // Kita harus menggunakan .contains karena path rute mungkin memiliki path turunan (nested)
    if (location.contains(AppRoutes.cluster)) return 0;
    if (location.contains(AppRoutes.sites)) return 1;
    if (location.contains(AppRoutes.dashboard)) {
      // Periksa apakah ini adalah rute Profil yang bersarang di Dashboard
      if (location.contains(AppRoutes.profile)) return 3;
      return 2;
    }
    // Default ke tab pertama jika tidak cocok
    return 0;
  }

  // Menangani ketika tab ditekan
  void _onItemTapped(BuildContext context, int index) {
    if (index < tabs.length) {
      final String location = tabs[index].location;

      // Jika tab yang ditekan adalah Profil, kita harus memastikan navigasi ke rute bersarang yang benar
      if (location == AppRoutes.profile) {
        context.go('/${AppRoutes.dashboard}/${AppRoutes.profile}');
      } else {
        context.go(location); // Navigasi ke rute utama
      }
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
        unselectedItemColor: primaryTextColor.withOpacity(0.6),
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

        items: tabs.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }
}
