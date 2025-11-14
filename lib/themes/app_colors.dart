// lib/themes/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // 1. Primary Colors (Warna Utama Aplikasi)
  static const Color primary = Color(0xFF1976D2); // Biru Gelap
  static const Color secondary = Color(0xFFFFC107); // Kuning Amber
  static const Color accent = Color(0xFF00BCD4); // Cyan

  // 2. Background & Surface Colors
  static const Color backgroundLight = Color(0xFFFFFFFF); // Putih
  static const Color backgroundDark = Color(0xFF121212); // Hampir Hitam
  static const Color cardSurface = Color(0xFFF5F5F5); // Abu-abu Sangat Terang

  // 3. Text Colors
  static const Color textPrimary = Color(0xFF212121); // Hitam
  static const Color textSecondary = Color(0xFF3F3F47); // Abu-abu
  static const Color textOnPrimary = Color(
    0xFFFFFFFF,
  ); // Putih (untuk di atas warna primary)

  // 4. State Colors (Warna Status)
  static const Color error = Color(0xFFD32F2F); // Merah
  static const Color success = Color(0xFF388E3C); // Hijau
  static const Color warning = Color(0xFFFFA000); // Oranye

  // 5. Border & Divider Colors
  static const Color border = Color(0xFFE5E7EB); // Abu-abu Medium
  static const Color divider = Color(0xFFE0E0E0); // Abu-abu Terang

  // Button Colors
  static const Color buttonBackground = Color(0xFF3F3F47);
}
