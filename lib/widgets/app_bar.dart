import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aerion_dashboard/themes/app_colors.dart';

// Definisi warna yang sering digunakan
const Color _kPrimaryTextColor = AppColors.textOnPrimary;
const Color _kSecondaryTextColor = AppColors.textOnSecondary;
const Color _kAppBarBackgroundColor = Colors.white;

/// Widget Custom AppBar yang dapat digunakan kembali, mengimplementasikan
/// PreferredSizeWidget untuk memastikan posisinya fixed di atas.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget?
  leading; // Widget di sisi kiri (jika bukan tombol kembali default)
  final Widget? trailing; // Widget di sisi kanan (misalnya Icon Settings/Notif)
  final bool showBackButton; // Kontrol tombol kembali
  final VoidCallback? onBack; // Aksi kustom saat tombol kembali ditekan
  final Color backgroundColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle = '',
    this.leading,
    this.trailing,
    this.showBackButton = true,
    this.onBack,
    this.backgroundColor = _kAppBarBackgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Tombol kembali default menggunakan context.pop()
    final Widget defaultLeading = showBackButton
        ? IconButton(
            icon: SvgPicture.asset('assets/svg/chevron-left.svg'),
            onPressed:
                onBack ??
                () {
                  // Menggunakan canPop untuk mencegah crash jika tidak ada rute sebelumnya
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/dashboard');
                    // Opsional: Navigasi ke rute default jika tidak bisa pop
                    // context.go('/cluster');
                  }
                },
          )
        : const SizedBox.shrink();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0.0,
      // Menggunakan widget leading kustom jika disediakan, jika tidak gunakan defaultLeading
      leading: showBackButton ? leading ?? defaultLeading : null,

      // Judul
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _kPrimaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'GeistSemibold',
            ),
          ),
          if (subtitle.isNotEmpty) const SizedBox(height: 4),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(
                color: _kSecondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'GeistRegular',
              ),
            ),
        ],
      ),

      // Ikon Aksi (Tambahkan Padding/SizedBox di sekitarnya)
      actions: trailing != null ? [trailing!, const SizedBox(width: 8)] : null,
    );
  }

  // Wajib diimplementasikan untuk AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
