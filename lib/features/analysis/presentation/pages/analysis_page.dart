import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentGreen = Color(
    0xFF10B981,
  ); // Warna hijau untuk grafik

  // Widget Header Tanggal & Pengaturan
  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '24 November 2025', // Tanggal Saat Ini
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/settings.svg',
                width: 24,
                height: 24,
                color: primaryTextColor,
              ),
              onPressed: () {
                // Aksi: Navigasi ke Settings
                context.go('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Navigasi Tanggal & Waktu, dan Tombol Parameter
  Widget _buildNavigatorAndParameters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tombol Panah Kiri
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: primaryTextColor,
            ),
            onPressed: () {},
          ),

          // Dropdown Tanggal & Waktu
          Expanded(
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '01 Sept 2025 - 12:35:12 PM',
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: primaryTextColor,
                  ),
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (String? newValue) {},
                  items:
                      <String>[
                        '01 Sept 2025 - 12:35:12 PM',
                        '02 Sept 2025 - 10:00:00 AM',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),

          // Tombol Panah Kanan
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: primaryTextColor,
            ),
            onPressed: () {},
          ),

          const SizedBox(width: 16),

          // Tombol Set Parameters
          ElevatedButton(
            onPressed: () {
              // Aksi: Buka modal atau halaman untuk mengatur parameter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Set Parameters clicked')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentGreen,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Set Parameters',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Placeholder untuk Grafik Garis
  Widget _buildChartPlaceholder() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Area Chart (Simulasi)
            Expanded(
              child: Center(
                child: Container(
                  // Area yang seharusnya diisi oleh Fl_chart atau chart library lainnya
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Output Voltage (V) Chart Data',
                      style: TextStyle(color: accentGreen, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Legend
            _buildLegendItem(label: 'Output Voltage (V)', color: accentGreen),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Legend
  Widget _buildLegendItem({required String label, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: primaryTextColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kustom
          _buildCustomAppBar(context),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8.0),
                  child: Text(
                    'Energy Chart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ),

                // Navigasi & Tombol Parameter
                _buildNavigatorAndParameters(context),

                const SizedBox(height: 16),

                // Area Grafik
                _buildChartPlaceholder(),
              ],
            ),
          ),

          // Sisanya diisi dengan Padding kosong jika tidak ada konten lain
          const Spacer(),
        ],
      ),
    );
  }
}
