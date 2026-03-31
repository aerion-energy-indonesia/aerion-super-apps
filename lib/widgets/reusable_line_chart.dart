import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Definisi Model Data untuk satu titik pada grafik
class ChartPoint {
  final double x; // Sumbu X (Biasanya Waktu/Durasi)
  final double y; // Sumbu Y (Nilai data)

  ChartPoint(this.x, this.y);
}

/// Widget Line Chart yang dapat digunakan kembali untuk membandingkan dua set data (misalnya Generasi vs Beban).
class ReusableLineChart extends StatelessWidget {
  final List<ChartPoint> generationData; // Data Power Generation (Garis 1)
  final List<ChartPoint> usageData; // Data Load Usage (Garis 2)
  final String yAxisLabel; // Label Sumbu Y (misalnya 'kW' atau 'V')
  final double maxY; // Nilai maksimum pada Sumbu Y

  const ReusableLineChart({
    super.key,
    required this.generationData,
    required this.usageData,
    this.yAxisLabel = 'kW',
    this.maxY = 20.0,
  });

  // Warna Konstan
  static const Color accentBlue = Color(0xFF3B82F6); // Generation
  static const Color accentRed = Color(0xFFEF4444); // Usage
  static const Color primaryTextColor = Color(0xFF364153);

  // Implementasi Grafik
  LineChartData get _lineChartData => LineChartData(
    // Menghilangkan touch input (opsional, tergantung kebutuhan)
    lineTouchData: const LineTouchData(enabled: true),

    // Konfigurasi Grid Lines
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: maxY / 4, // Misalnya, 4 garis horizontal
      verticalInterval: 2, // Setiap 2 unit di sumbu X
      getDrawingHorizontalLine: (value) =>
          FlLine(color: Colors.grey, strokeWidth: 0.2),
      getDrawingVerticalLine: (value) =>
          FlLine(color: Colors.grey, strokeWidth: 0.2),
    ),

    // Konfigurasi Axis Titles dan Labels
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        // Sumbu Y (Vertikal Kiri)
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: maxY / 4,
          getTitlesWidget: (value, meta) {
            // Tampilkan label sumbu Y (0, 5, 10, 15, 20)
            if (value == 0) return const SizedBox(); // Hilangkan label 0
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.right,
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        // Sumbu X (Horizontal Bawah)
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          interval: 2, // Tampilkan label setiap 2 jam
          getTitlesWidget: (value, meta) {
            // Konversi nilai X menjadi format waktu (misalnya 02:00, 04:00, ...)
            final hours = value.toInt().toString().padLeft(2, '0');
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$hours:00',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),

    // Konfigurasi Border
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey.shade300, width: 1.5),
    ),

    // Batas Grafik
    minX: 0,
    maxX: 24, // Asumsi 24 jam penuh
    minY: 0,
    maxY: maxY,

    // Daftar Garis
    lineBarsData: [
      // Garis 1: Power Generation
      _buildLineBar(generationData, accentBlue),
      // Garis 2: Load Usage
      _buildLineBar(usageData, accentRed),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Memastikan data valid dan controller sudah diinisialisasi
    if (generationData.isEmpty || usageData.isEmpty) {
      return const Center(child: Text("Data grafik tidak tersedia."));
    }

    return AspectRatio(
      aspectRatio: 1.7, // Rasio aspek chart
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 10,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(_lineChartData),
      ),
    );
  }
}

// =========================================================================
// HELPER FUNGSIONAL
// =========================================================================

/// Membangun konfigurasi LineChartBarData untuk satu garis.
LineChartBarData _buildLineBar(List<ChartPoint> data, Color color) {
  return LineChartBarData(
    spots: data.map((point) => FlSpot(point.x, point.y)).toList(),
    isCurved: true, // Garis melengkung (smooth)
    barWidth: 2,
    color: color,
    dotData: const FlDotData(show: false), // Hilangkan titik pada garis
    belowBarData: BarAreaData(
      show: true,
      color: color.withOpacity(
        0.1,
      ), // Area di bawah garis dengan opasitas rendah
    ),
  );
}
