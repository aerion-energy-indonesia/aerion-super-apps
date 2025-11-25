import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// Model dasar untuk data yang ditampilkan di halaman
class DashboardData {
  final String clusterName;
  final String siteName;
  final String siteAddress;

  DashboardData({
    required this.clusterName,
    required this.siteName,
    required this.siteAddress,
  });
}

// =========================================================================
// WIDGET PLACEHOLDER/HELPER (Harus dipindahkan ke file terpisah di aplikasi nyata)
// =========================================================================

// Widget kecil untuk menampilkan Key-Value Pair (seperti PV Output)
class KeyValueItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const KeyValueItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = const Color(0xFF10B981), // Default Green
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: valueColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET UTAMA
// =========================================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late VideoPlayerController _videoController;
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFE41E26);
  static const Color komatsuBlue = Color(0xFF00305E);
  static const Color secondaryTextColor = Colors.grey;
  late DateTime _currentDateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() => _currentDateTime = DateTime.now());
      }
    });

    _videoController =
        VideoPlayerController.asset('assets/videos/super-apps.mp4')
          ..initialize().then((_) {
            // Pastikan video mulai diputar dan loop
            _videoController.play();
            _videoController.setLooping(true);
            // Refresh UI setelah inisialisasi selesai
            setState(() {});
          });
  }

  // Data mock halaman
  DashboardData _getMockData() {
    return DashboardData(
      clusterName: 'KUI Cikarang',
      siteName: 'Plant A',
      siteAddress:
          'Jl. Gatot Subroto No. Kav. 52, Kuningan Barat, Jakarta Selatan',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  // HAPUS _buildCustomAppBar kustom dari sini karena akan digantikan oleh widget CustomAppBar

  // Bagian Header Situs & Diagram
  Widget _buildSiteHeaderAndDiagram(BuildContext context, DashboardData data) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Diagram Sistem (Image/Simulasi)
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Center(
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ), // Loading indicator
            ),
          ),

          // Info Perusahaan
          Row(
            children: [
              const Icon(
                Icons.business_center,
                color: komatsuBlue,
                size: 24,
              ), // Placeholder Logo
              const SizedBox(width: 8),
              Text(
                'KOMATSU',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: komatsuBlue,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman Edit Site/Cluster
                },
                child: const Text(
                  'Change Sites',
                  style: TextStyle(color: komatsuBlue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nama & Alamat Situs
          Text(
            data.siteName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.siteAddress,
            style: TextStyle(fontSize: 13, color: secondaryTextColor),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Bagian Current Load
  Widget _buildCurrentLoadPanel() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Load',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '9.993 kW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLoadMetric('Total Load', '10.221 kW', secondaryTextColor),
                _buildLoadMetric(
                  'Average Load',
                  '9.512 kW',
                  secondaryTextColor,
                ),
                _buildLoadMetric('Min Load', '8.981 kW', secondaryTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Metrik Load
  Widget _buildLoadMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: color)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ],
    );
  }

  // Bagian Current Power
  Widget _buildCurrentPowerPanel() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Power',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '9.946 kW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid 2x4 untuk Power Sources
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3, // Mengatur rasio agar item lebih lebar
              mainAxisSpacing: 8,
              crossAxisSpacing: 16,
              children: [
                // Source 1: PV
                KeyValueItem(
                  label: 'PV Output',
                  value: '0.320 kW',
                  icon: Icons.wb_sunny,
                  valueColor: accentGreen,
                ),
                // Source 2: PV from HVDS Tower
                KeyValueItem(
                  label: 'PV from HVDS Tower',
                  value: '1.100 kW',
                  icon: Icons.wifi,
                  valueColor: accentGreen,
                ),
                // Source 3: Bus Tracking System
                KeyValueItem(
                  label: 'Bus Tracking System',
                  value: '0.282 kW',
                  icon: Icons.directions_bus,
                  valueColor: accentGreen,
                ),
                // Source 4: Battery Package
                KeyValueItem(
                  label: 'Battery Package',
                  value: '6.520 kW',
                  icon: Icons.battery_charging_full,
                  valueColor: accentGreen,
                ),
                // Source 5: Electricity
                KeyValueItem(
                  label: 'Electricity',
                  value: '0.490 kW',
                  icon: Icons.bolt,
                  valueColor: accentGreen,
                ),
                // Source 6: Wall Mounted Flex PV
                KeyValueItem(
                  label: 'Wall Mounted Flex PV',
                  value: '1.520 kW',
                  icon: Icons.power,
                  valueColor: accentGreen,
                ),
                // Source 7: Primary
                KeyValueItem(
                  label: 'Primary',
                  value: '0.347 kW',
                  icon: Icons.star,
                  valueColor: accentRed,
                ),
                // Source 8: Grid PLM
                KeyValueItem(
                  label: 'Grid PLM',
                  value: '0.436 kW',
                  icon: Icons.grid_on,
                  valueColor: accentRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bagian Load Supply Today
  Widget _buildLoadSupplyPanel() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Load Supply Today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '17.215 kWh',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Supply Energy',
              style: TextStyle(fontSize: 13, color: secondaryTextColor),
            ),
            // Anda dapat menambahkan placeholder chart di sini jika diperlukan
          ],
        ),
      ),
    );
  }

  // Bagian Battery Overview
  Widget _buildBatteryOverviewPanel() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview Battery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Circular Chart
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0, // Full
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(accentGreen),
                      ),
                      const Text(
                        '100%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SOC (State of Charge)',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detail Baterai (Tabel)
            _buildBatteryDetailRow('Status', 'Full Charged', accentGreen),
            _buildBatteryDetailRow(
              'Daily Charging Volume',
              '29 kWh',
              primaryTextColor,
            ),
            _buildBatteryDetailRow(
              'Battery Temperature',
              '28 °C',
              primaryTextColor,
            ),
            _buildBatteryDetailRow(
              'State of Health (SOH)',
              'Excellent',
              accentGreen,
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Detail Baris Baterai
  Widget _buildBatteryDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Carbon Reduction
  Widget _buildCarbonReductionPanel() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carbon Reduction Today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '62 kg',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: primaryTextColor,
                  ),
                ),
                Text(
                  '6.85 kg',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Carbon Reduction',
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
                Text(
                  'Total Revenue 124.790.212 IDR',
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Placeholder Bar Chart (Simulasi)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text('Simulasi Bar Chart Carbon')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _getMockData();
    final timeFormat = DateFormat('hh:mm:ss a');
    final dateFormat = DateFormat('d MMMM yyyy');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: dateFormat.format(_currentDateTime),
        subtitle: timeFormat.format(_currentDateTime),
        showBackButton: false, // Dashboard tidak punya tombol back
        trailing: IconButton(
          icon: SvgPicture.asset('assets/svg/settings.svg'),
          onPressed: () {
            // Navigasi ke Settings
            context.go('/settings');
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // 2. Header Situs dan Diagram
              _buildSiteHeaderAndDiagram(context, data),

              // 3. Konten Utama Dashboard (Padding luar)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),

                    // Current Load
                    _buildCurrentLoadPanel(),

                    const SizedBox(height: 24),

                    // Current Power
                    _buildCurrentPowerPanel(),

                    const SizedBox(height: 24),

                    // Load Supply Today
                    _buildLoadSupplyPanel(),

                    const SizedBox(height: 24),

                    // Battery Overview
                    _buildBatteryOverviewPanel(),

                    const SizedBox(height: 24),

                    // Carbon Reduction Today
                    _buildCarbonReductionPanel(),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
