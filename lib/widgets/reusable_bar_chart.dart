import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// --- DUMMY COLOR DEFINITIONS (Ganti dengan AppColors Anda) ---
const Color primaryTextColor = Color(0xFF1F2937);
const Color accentOrange = Color(0xFFF97316);
const Color barBackground = Color(
  0xFFF3F4F6,
); // Warna abu-abu terang untuk latar batang (Inactive)
const Color defaultBarColor = Color(
  0xFF1F2937,
); // Warna Hitam/Gelap untuk batang aktif
const Color labelColor = Color(0xFF6B7280);
// --- END DUMMY COLOR DEFINITIONS ---

// Definisi Model Data untuk satu bar pada grafik
class BarData {
  final double x; // Posisi Bar di sumbu X (misalnya Hari ke-1, ke-2)
  final double y; // Nilai Bar di sumbu Y
  final String label; // Label di bawah Bar (misalnya 'Sen', 'Sel')
  final bool isToday; // NEW: Menandakan batang hari ini

  BarData({
    required this.x,
    required this.y,
    required this.label,
    this.isToday = false,
  });
}

/// Widget Bar Chart yang dapat digunakan kembali untuk perbandingan data interval.
class ReusableBarChart extends StatelessWidget {
  final List<BarData> data;
  final double maxY;
  // Menghapus barColor default karena warna ditentukan berdasarkan isToday
  final Color todayColor;
  final Color defaultBarColor;
  final Color inactiveColor;

  const ReusableBarChart({
    super.key,
    required this.data,
    required this.maxY,
    this.todayColor = accentOrange,
    this.defaultBarColor = primaryTextColor,
    this.inactiveColor = barBackground,
  });

  // Konfigurasi Bar Chart
  BarChartData get _barChartData => BarChartData(
    barTouchData: const BarTouchData(
      enabled: false,
    ), // Nonaktifkan tooltip sentuh
    // --- HILANGKAN SEMUA JUDUL & GARIS GRID ---
    titlesData: FlTitlesData(
      show: true,
      // Hilangkan sumbu Kanan dan Atas
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ), // Hilangkan sumbu Kiri
      // Sumbu Bawah (Label Tanggal)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            // Cari label berdasarkan nilai X
            final bar = data.firstWhere(
              (element) => element.x == value,
              orElse: () => BarData(x: 0, y: 0, label: ''),
            );
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                bar.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: labelColor,
                ), // Font lebih besar dan warna abu-abu gelap
              ),
            );
          },
          reservedSize: 30,
        ),
      ),
    ),

    borderData: FlBorderData(show: false), // Hilangkan border chart
    gridData: const FlGridData(show: false), // Hilangkan garis grid
    // ------------------------------------------

    // Batas Grafik
    maxY: maxY,
    minY: 0,
    alignment: BarChartAlignment.spaceAround,
    groupsSpace: 20, // Jarak antar batang (sesuaikan)
    // Daftar Bar
    barGroups: data.map((item) {
      // Tentukan warna batang dan shadow
      final bool isToday = item.isToday;
      final Color barFillColor = isToday ? todayColor : defaultBarColor;

      return BarChartGroupData(
        x: item.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: item.y, // Nilai yang dicapai batang
            color: barFillColor, // Warna batang nilai
            width: 15, // Lebar bar
            borderRadius: const BorderRadius.only(
              // Sudut atas melengkung
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),

            // =================================================================
            // KUSTOMISASI: MENYIMULASIKAN BATANG BELAKANG (ABU-ABU)
            // =================================================================
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY, // Batang latar belakang mencapai tinggi maksimum
              color: inactiveColor, // Warna abu-abu terang
            ),

            // =================================================================
            // KUSTOMISASI: EFEK GLOW (SHADOW)
            // =================================================================
            // Jika hari ini, tambahkan bayangan untuk efek glow oranye
            rodStackItems: isToday
                ? [
                    BarChartRodStackItem(
                      0, // Mulai dari 0
                      item.y, // Sampai nilai y
                      barFillColor, // Warna batang
                    ),
                  ]
                : null, // Jangan pakai stack item/shadow jika bukan hari ini
          ),
        ],
        showingTooltipIndicators: [],
      );
    }).toList(),
  );

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Data bar chart tidak tersedia."));
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        // Padding disesuaikan agar tidak ada space untuk sumbu Y di kiri
        padding: const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 0),
        child: BarChart(_barChartData),
      ),
    );
  }
}
