import 'package:flutter/material.dart';
import '../../../../themes/app_colors.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordLink({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bagian Teks Statis
          const Text(
            'Forgot Password? ', // Tambahkan 1 spasi di sini
            style: TextStyle(
              color: Color(0xFF3F3F47),
              fontFamily: 'GeistRegular',
              fontWeight: FontWeight.w500,
            ),
          ),

          // Bagian Tombol yang Dapat Diklik (Click Here)
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              // 1. HILANGKAN SEMUA PADDING BAWAAN TextButton
              padding: WidgetStateProperty.all(EdgeInsets.zero),

              // 2. HILANGKAN JUGA MINIMUM SIZE BAWAAN
              minimumSize: WidgetStateProperty.all(Size.zero),

              // 3. Optional: Hilangkan efek splash/highlight jika tidak diperlukan
              // tapTargetSize: MaterialTapTargetSize.shrinkWrap,

              // Customisasi warna dan border lainnya
              shape: WidgetStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide.none,
                ),
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                Colors.white54, // Warna tombol saat ditekan/fokus
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white54.withOpacity(0.04);
                }
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white70.withOpacity(0.12);
                }
                return null; // Gunakan default
              }),
            ),
            child: const Text(
              'Click Here',
              style: TextStyle(
                color: Color(0xFF6A7282),
                fontFamily: 'GeistSemiBold',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
