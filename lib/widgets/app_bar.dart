import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Definisi warna yang sering digunakan
const Color _kPrimaryTextColor = Color(0xFF364153);
const Color _kAppBarBackgroundColor = Colors.white;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing; // Widget di sisi kanan (misalnya Icon Settings)
  final bool showBackButton; // Kontrol tombol kembali
  final VoidCallback? onBack; // Aksi kustom saat tombol kembali ditekan

  const CustomAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Tinggi AppBar standar
      automaticallyImplyLeading: false,

      backgroundColor: _kAppBarBackgroundColor,
      elevation: 0, // AppBar tanpa shadow
      // Tombol Kembali
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: _kPrimaryTextColor),
              onPressed:
                  onBack ??
                  () => context.pop(), // Gunakan context.pop() default
            )
          : null,

      // Judul
      title: Text(
        title,
        style: const TextStyle(
          color: _kPrimaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Ikon Aksi
      actions: trailing != null ? [trailing!, const SizedBox(width: 8)] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
