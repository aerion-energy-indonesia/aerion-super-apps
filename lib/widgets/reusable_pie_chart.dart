import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReusablePieChartWithIcon extends StatelessWidget {
  // Menghapus `percentage`, `inactiveColor` karena kita tidak lagi menggunakan PieChart
  // Kita hanya perlu activeColor untuk lingkaran dan icon
  final double radius;
  final Color activeColor;
  final String icon; // Path asset SVG

  const ReusablePieChartWithIcon({
    super.key,
    this.radius = 40.0, // Radius untuk seluruh lingkaran
    this.activeColor = const Color(0xFF10B981), // Warna hijau cerah
    this.icon = 'assets/svg/ic-battery.svg', // Default icon, jika perlu
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran total container akan menjadi dua kali radius
    final double containerSize = radius * 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background lingkaran penuh (sebagai border)
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: activeColor, // Border lingkaran menggunakan activeColor
              width: 6.0, // Ketebalan border
            ),
            // Opsional: Jika ingin ada sedikit warna di dalam border (tidak terlalu terlihat di gambar)
            // color: activeColor.withOpacity(0.1),
          ),
        ),

        // Icon SVG di tengah dengan efek glow
        SizedBox(
          width:
              containerSize *
              0.8, // Ukuran icon relatif terhadap lingkaran luar
          height: containerSize * 0.8,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: activeColor.withOpacity(0.1), // Base color untuk efek glow
          //   boxShadow: [
          //     BoxShadow(
          //       color: activeColor.withOpacity(0.4), // Warna glow
          //       blurRadius: 10, // Seberapa menyebar glow-nya
          //       spreadRadius: 2, // Seberapa jauh glow-nya menyebar dari batas
          //     ),
          //   ],
          // ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                activeColor,
                BlendMode.srcIn,
              ), // Mengubah warna SVG
              width:
                  containerSize *
                  5, // Ukuran icon SVG (lebih kecil dari container glow)
              height: containerSize * 5,
            ),
          ),
        ),
      ],
    );
  }
}
