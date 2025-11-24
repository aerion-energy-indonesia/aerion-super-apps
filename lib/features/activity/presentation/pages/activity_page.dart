import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Model untuk data rinci log
class EnergyLog {
  final String time;
  final String powerGeneration;
  final String loadUsage;

  EnergyLog({
    required this.time,
    required this.powerGeneration,
    required this.loadUsage,
  });
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentBlue = Color(
    0xFF3B82F6,
  ); // Warna biru untuk generation
  static const Color accentRed = Color(0xFFEF4444); // Warna merah untuk usage

  // Data Mock untuk List Log
  List<EnergyLog> _mockLogData() {
    return [
      EnergyLog(
        time: '12:35:01',
        powerGeneration: '9.820 kW',
        loadUsage: '7.258 kW',
      ),
      EnergyLog(
        time: '12:30:01',
        powerGeneration: '10.193 kW',
        loadUsage: '7.522 kW',
      ),
      EnergyLog(
        time: '12:25:01',
        powerGeneration: '10.321 kW',
        loadUsage: '7.525 kW',
      ),
      EnergyLog(
        time: '12:20:01',
        powerGeneration: '10.521 kW',
        loadUsage: '7.451 kW',
      ),
      EnergyLog(
        time: '12:15:01',
        powerGeneration: '10.821 kW',
        loadUsage: '7.518 kW',
      ),
      EnergyLog(
        time: '12:10:01',
        powerGeneration: '11.328 kW',
        loadUsage: '7.692 kW',
      ),
      EnergyLog(
        time: '12:05:01',
        powerGeneration: '11.279 kW',
        loadUsage: '7.882 kW',
      ),
      EnergyLog(
        time: '12:00:01',
        powerGeneration: '10.125 kW',
        loadUsage: '7.625 kW',
      ),
      EnergyLog(
        time: '11:55:01',
        powerGeneration: '8.921 kW',
        loadUsage: '8.214 kW',
      ),
      EnergyLog(
        time: '11:50:01',
        powerGeneration: '8.512 kW',
        loadUsage: '8.192 kW',
      ),
      EnergyLog(
        time: '11:45:01',
        powerGeneration: '8.761 kW',
        loadUsage: '6.912 kW',
      ),
      EnergyLog(
        time: '11:40:01',
        powerGeneration: '9.211 kW',
        loadUsage: '7.129 kW',
      ),
    ];
  }

  // Widget Placeholder untuk Grafik Garis (Area yang kompleks)
  Widget _buildChartPlaceholder(BuildContext context) {
    // Kita simulasi area chart dengan Container
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          'Simulasi Grafik Energi (Power Generation vs Load Usage)',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logData = _mockLogData();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // AppBar Kustom
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            automaticallyImplyLeading:
                false, // Menghilangkan tombol back default
            title: const Text(
              '24 November 2025', // Tanggal Saat Ini
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/settings.svg'),
                onPressed: () {
                  // Aksi: Navigasi ke Settings
                  context.go('/settings');
                },
              ),
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Energy Chart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ringkasan Total Daya
                    Text(
                      'Total Power 5,818.61 kWh',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tab Bar untuk Hari/Bulan/Tahun
                    _buildTimeTabs(),

                    // Kontainer Chart (Placeholder)
                    _buildChartPlaceholder(context),

                    // Legend Grafik
                    _buildChartLegend(),

                    const SizedBox(height: 16),

                    // Summary Cards (Power Generation & Load Usage)
                    _buildSummaryCards(),

                    const SizedBox(height: 24),

                    // Detail Data Log
                    const Text(
                      'Activity Log Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tabel/List Data Log
                    _buildLogTable(logData),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Widget Tab Hari/Bulan/Tahun
  Widget _buildTimeTabs() {
    // Kita simulasi tampilan tab yang solid
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['Day', 'Month', 'Year'].map((label) {
          // Simulasi tab 'Day' aktif
          bool isActive = label == 'Day';
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: isActive
                      ? accentBlue.withOpacity(0.1)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? accentBlue : primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget Legend Grafik
  Widget _buildChartLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(label: 'Power Generation', color: accentBlue),
          const SizedBox(width: 24),
          _buildLegendItem(label: 'Load Usage', color: accentRed),
        ],
      ),
    );
  }

  // Widget Pembantu untuk Legend
  Widget _buildLegendItem({required String label, required Color color}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, color: primaryTextColor)),
      ],
    );
  }

  // Widget Summary Cards
  Widget _buildSummaryCards() {
    return Row(
      children: [
        // Card 1: Power Generation
        Expanded(
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Power Generation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '119.816 kWh',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Card 2: Load Usage
        Expanded(
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Load Usage',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '90.920 kWh',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: accentRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget Log Table (Menggunakan DataTable atau ListView, saya pilih ListView/Column untuk responsif)
  Widget _buildLogTable(List<EnergyLog> logs) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        children: [
          // Header Tabel
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: const [
                SizedBox(
                  width: 70,
                  child: Text(
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Power Generation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Load Usage',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Baris Data
          ...logs.map((log) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(log.time, style: const TextStyle(fontSize: 13)),
                  ),
                  Expanded(
                    child: Text(
                      log.powerGeneration,
                      style: TextStyle(color: accentBlue, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      log.loadUsage,
                      style: TextStyle(color: accentRed, fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
