import 'package:flutter/material.dart';
import '../../../../themes/app_colors.dart';

class TextLink extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String linkLabel;

  const TextLink({
    super.key,
    required this.onPressed,
    required this.label,
    required this.linkLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bagian Teks Statis
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'GeistRegular',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),

          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(Size.zero),
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
            child: Text(
              linkLabel,
              style: TextStyle(
                color: Color(0xFF6A7282),
                fontFamily: 'GeistSemiBold',
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
