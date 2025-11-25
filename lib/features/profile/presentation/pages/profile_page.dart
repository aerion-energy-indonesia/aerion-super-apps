import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aerion_dashboard/themes/app_colors.dart';

// Asumsi: Path ke AuthNotifier dan AppRoutes sudah benar
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../../routes/app_routes.dart';
// Import widget/halaman yang diperlukan

// --- ASUMSI: DEFINISI SVG ICON HELPER (diambil dari AppRouter/MainScaffold) ---
// Ini harus dipindahkan ke file utilitas di proyek Anda agar dapat diakses

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
    return SvgPicture.asset(
      assetPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: size,
      height: size,
      placeholderBuilder: (BuildContext context) =>
          Icon(Icons.error, color: color),
    );
  }
}
// --- END ASUMSI SVG ICON HELPER ---

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentColor = Color(0xFF00305E);
  static const Color logoutColor = Color(0xFFE41E26); // Merah untuk Logout

  // Widget Pembantu untuk Opsi Pengaturan
  Widget _buildSettingOption({
    required BuildContext context,
    required String assetPath, // Menggunakan path aset SVG
    required String title,
    required String route,
    Color iconColor = primaryTextColor,
    bool isLogout = false,
  }) {
    // Aksi yang akan dipanggil saat item diklik
    final VoidCallback onTapAction = isLogout
        ? () {
            // Panggil fungsi logout dari AuthNotifier
            Provider.of<AuthNotifier>(context, listen: false).signOut();
            context.go(AppRoutes.login); // Arahkan ke Login Page
          }
        : () {
            // Navigasi ke rute tujuan (Diasumsikan rute di luar Shell adalah root-level)
            // Untuk rute pengaturan, kita gunakan /settings/sub-route
            context.go('${AppRoutes.settings}/$route');
          };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),

        // MENGGANTI ICON DENGAN SVG ICON BUILDER
        leading: SvgPicture.asset(assetPath),

        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isLogout ? logoutColor : primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLogout
            ? null // Tidak ada panah untuk Logout
            : const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTapAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari AuthNotifier untuk tampilan header
    final authState = context.watch<AuthNotifier>().state;
    final user = authState.user;

    final String username = user?.username ?? 'Pengguna Tidak Dikenal';
    final String email = user?.email ?? 'email@komatsu.com';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Setting',
        showBackButton: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =========================================================
            // 1. Header Profil & Edit Data
            // =========================================================
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.accent,
                        child: SvgPicture.asset(
                          'assets/svg/user.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Tombol Edit Data
                  TextButton(
                    onPressed: () {
                      // MENGGUNAKAN RUTE FULL-SCREEN
                      context.go('${AppRoutes.settings}/change-profile');
                    },
                    child: const Text(
                      'Edit Data',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================
            // 2. Daftar Opsi Pengaturan
            // =========================================================
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Opsi 1: Change Cluster
                  _buildSettingOption(
                    context: context,
                    assetPath: 'assets/svg/maps.svg',
                    title: 'Change Cluster',
                    route: AppRoutes.changeCluster,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  ),

                  // Opsi 2: Change Password
                  _buildSettingOption(
                    context: context,
                    assetPath: 'assets/svg/password.svg',
                    title: 'Change Password',
                    route: AppRoutes.changePassword,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  ),

                  // Opsi 3: Language Setting
                  _buildSettingOption(
                    context: context,
                    assetPath: 'assets/svg/language.svg',
                    title: 'Language Setting',
                    route: AppRoutes.languageSettings,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  ),

                  // Opsi 4: About Us
                  _buildSettingOption(
                    context: context,
                    assetPath: 'assets/svg/about.svg',
                    title: 'About Us',
                    route: AppRoutes.aboutUs,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  ),

                  // Opsi 5: Help
                  _buildSettingOption(
                    context: context,
                    assetPath: 'assets/svg/help.svg',
                    title: 'Help',
                    route: AppRoutes.help,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================
            // 3. Opsi Logout
            // =========================================================
            Container(
              color: Colors.white,
              child: _buildSettingOption(
                context: context,
                assetPath: 'assets/svg/logout.svg',
                title: 'Logout',
                route: '', // Tidak digunakan untuk Logout
                iconColor: logoutColor,
                isLogout: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
