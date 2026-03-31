import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:aerion_dashboard/themes/app_colors.dart'; // Asumsikan AppCustomColors sudah diimpor

// Definisikan warna dummy jika AppCustomColors tidak dapat diakses
class AppCustomColors {
  static const Color textSecondary = Colors.grey;
  static const Color textPrimary = Colors.black87;
  static const Color background = Colors.white;
}

class TextInfoWithIcon extends StatelessWidget {
  final String title;
  final double size;
  final String description;
  final Color iconColor;
  final Color textColor;

  const TextInfoWithIcon({
    super.key,
    required this.title,
    required this.size,
    required this.description,
    this.iconColor = AppCustomColors.textPrimary,
    this.textColor = AppCustomColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan Builder untuk mendapatkan context dari Row, agar bisa mendapatkan posisi render box.
    return Builder(
      builder: (innerContext) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Panggil dialog dengan context baru
                _showInfoDialog(innerContext, title, description);
              },
              child: Transform.translate(
                // Geser ikon ke atas sebesar 2.0 atau 3.0 pixel (sesuaikan)
                // Nilai negatif pada sumbu Y memindahkan widget ke atas
                offset: const Offset(-2.0, -4.0),
                child: SvgPicture.asset(
                  'assets/svg/info.svg', // Pastikan path SVG ini benar
                  height: size - 4,
                  width: size - 4,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan Popover/Dialog bergaya Tooltip
  void _showInfoDialog(BuildContext context, String title, String description) {
    // Dapatkan posisi global dari widget yang ditekan
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Hitung posisi horizontal (sedikit ke kanan dari ikon) dan vertikal (di bawah ikon)
    const double dialogWidth = 350;
    const double paddingOffset = 16;

    // Tentukan posisi X agar popover berada di bawah ikon
    final double targetX = position.dx + size.width / 2 - (dialogWidth / 2);
    final double targetY =
        position.dy + size.height + 5; // 5 adalah jarak kecil dari ikon

    showDialog(
      context: context,
      barrierDismissible: true, // Boleh ditutup dengan tap di luar
      barrierColor:
          Colors.transparent, // Hapus background buram (Kunci tampilan popover)
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Posisi Popover menggunakan Positioned
            Positioned(
              left: targetX.clamp(
                paddingOffset,
                MediaQuery.of(context).size.width - dialogWidth - paddingOffset,
              ),
              top: targetY,
              child: Material(
                // Gunakan Material untuk elevasi dan shadow
                borderRadius: BorderRadius.circular(12),
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.4),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: dialogWidth),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppCustomColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Isi Konten Dialog: Judul Tebal + Deskripsi
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$title — ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppCustomColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: description,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: AppCustomColors.textPrimary.withOpacity(
                                  0.8,
                                ),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tambahkan tombol OK (jika diperlukan) atau biarkan ditutup dengan tap di luar
                      // Untuk desain popover seperti gambar, tombol OK tidak diperlukan.
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
