import 'package:aerion_dashboard/features/dashboard/presentation/widgets/text_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aerion_dashboard/widgets/bottom_sheet.dart';
import 'package:aerion_dashboard/themes/app_colors.dart';
import 'package:aerion_dashboard/widgets/reusable_pie_chart.dart';
import 'package:aerion_dashboard/widgets/reusable_bar_chart.dart';
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
  final String icon; // Path asset SVG
  final Color valueColor;

  const KeyValueItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = AppColors
        .textPrimary, // valueColor seharusnya tidak memiliki nilai default di sini jika AppColors tidak diimpor
  });

  @override
  Widget build(BuildContext context) {
    // Menghilangkan Expanded di tingkat tertinggi
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        // Column di tingkat ini sudah cukup
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Icon dan Label (Menyatukan Icon dan Label dalam satu Row untuk layout yang lebih baik)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon SVG
              SvgPicture.asset(icon, height: 20, width: 20),
              const SizedBox(
                width: 8,
              ), // Jarak horizontal antara icon dan label
              // Label
              // Menggunakan Flexible daripada Expanded penuh di sini untuk memberi ruang pada SvgPicture
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'GeistRegular',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 4,
          ), // Jarak vertikal antara Label/Icon dan Nilai
          // 2. Value (Nilai)
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Menyelaraskan teks 'kW' dengan nilai
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                  fontFamily: 'GeistRegular',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // Tambahan unit 'kW'
              Text(
                ' kW',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'GeistRegular',
                ),
              ),
            ],
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

  // Bagian Header Situs & Diagram
  Widget _buildSiteHeaderAndDiagram(BuildContext context, DashboardData data) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Diagram Sistem (Image/Simulasi)
          SizedBox(
            // height: 400,
            // width: double.infinity,
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/logo/komatsu.png'),
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data.clusterName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // open bottom sheet wegets/bottom_sheet.dart
                        MyBottomSheet.show(
                          context,
                          title: 'Change Sites',
                          content: const Text(
                            'Content for changing sites goes here.',
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Change Sites',
                            style: TextStyle(color: komatsuBlue, fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/svg/change.svg',
                            height: 16,
                            width: 16,
                          ),
                        ],
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
                  'SN: 12345678901234567890',
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  data.siteAddress,
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Info Perusahaan
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
                const TextInfoWithIcon(
                  title: 'Current Load',
                  size: 16,
                  description:
                      'The real-time electrical load being used at the moment.',
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
            const Divider(height: 24, thickness: 0.5, color: Colors.grey),
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
                const TextInfoWithIcon(
                  title: 'Current Power',
                  size: 16,
                  description:
                      'The total electrical power currently being produced or supplied from all energy sources in real time.',
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
            const Divider(height: 24, thickness: 0.5, color: Colors.grey),
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
                  label: 'VAWT',
                  value: '0.320',
                  icon: 'assets/svg/vawt.svg',
                ),
                // Source 2: PV from HVDS Tower
                KeyValueItem(
                  label: 'Flex PV HRES Tower',
                  value: '1.100',
                  icon: 'assets/svg/flex-pv.svg',
                ),
                // Source 3: Bus Tracking System
                KeyValueItem(
                  label: 'Sun Tracking System',
                  value: '0.282',
                  icon: 'assets/svg/sun-tracking-system.svg',
                ),
                // Source 4: Solar Rooftop
                KeyValueItem(
                  label: 'Solar Rooftop',
                  value: '0.347',
                  icon: 'assets/svg/solar-rooftop.svg',
                ),
                // Source 5: Perovskite
                KeyValueItem(
                  label: 'Perovskite',
                  value: '0.490',
                  icon: 'assets/svg/perovskite.svg',
                ),
                // Source 6: Wall Mounted Flex PV
                KeyValueItem(
                  label: 'Wall Mounted Flex PV',
                  value: '1.520',
                  icon: 'assets/svg/wall-mounted.svg',
                ),
                // Source 7: Battery
                KeyValueItem(
                  label: 'Battery',
                  value: '6.520',
                  icon: 'assets/svg/battery.svg',
                ),
                // Source 8: Grid PLM
                KeyValueItem(
                  label: 'Grid PLM',
                  value: '0.436',
                  icon: 'assets/svg/grid-pln.svg',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextInfoWithIcon(
              title: 'Load Supply Today',
              size: 16,
              description:
                  'The total amount of energy (kWh) supplied to the load throughout the day from all energy sources.',
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
              style: TextStyle(
                fontSize: 13,
                color: primaryTextColor,
                fontFamily: 'GeistRegular',
              ),
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
                      ReusablePieChartWithIcon(
                        radius: 40,
                        activeColor: accentGreen,
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
              'Day Charging Volume',
              '29 kWh',
              primaryTextColor,
            ),
            _buildBatteryDetailRow(
              'Daily Discharging Volume',
              '72 kWh',
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
            style: TextStyle(
              fontSize: 14,
              color: primaryTextColor,
              fontFamily: 'GeistRegular',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'GeistRegular',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ), // Sudut lebih membulat (16)
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================================
            // 1. ROW JUDUL UTAMA & NILAI HARI INI (Top Row)
            // ===================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carbon Reduction Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600, // Sedikit lebih ringan dari bold
                    color: primaryTextColor,
                  ),
                ),
                Text(
                  '5.85 kg', // Nilai ini datang dari sisi kanan desain
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===================================================================
            // 2. DUA KARTU INFO BAWAH JUDUL (Total Reduction & Total Revenue)
            // ===================================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to top
              children: [
                // --- Kiri: Total Carbon Reduction ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextInfoWithIcon(
                            title: 'Total Carbon Reduction',
                            size: 13,
                            description:
                                'The total carbon reduction achieved today through energy savings and renewable sources.',
                            textColor: secondaryTextColor,
                            iconColor: secondaryTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '12 kg', // Nilai Carbon Reduction
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextInfoWithIcon(
                            title: 'Total Revenue',
                            size: 13,
                            description:
                                'The total revenue generated from carbon reduction today.',
                            textColor: secondaryTextColor,
                            iconColor: secondaryTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '123.456.000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24), // Jarak antara nilai dan chart
            // ===================================================================
            // 3. BAR CHART KUSTOM SIMULASI
            // ===================================================================
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end, // Mulai dari bawah
                children: [
                  ReusableBarChart(
                    data: [
                      BarData(x: 1, y: 0.4, label: 'Mon'),
                      BarData(x: 2, y: 0.6, label: 'Tue'),
                      BarData(x: 3, y: 0.5, label: 'Wed'),
                      BarData(x: 4, y: 0.8, label: 'Thu'),
                      BarData(x: 5, y: 0.7, label: 'Fri'),
                      BarData(x: 6, y: 0.9, label: 'Sat'),
                      BarData(x: 7, y: 0.3, label: 'Sun'),
                    ],
                    maxY: 1.0,
                    todayColor: accentGreen,
                    defaultBarColor: primaryTextColor,
                    inactiveColor: barBackground,
                  ),
                ],
              ),
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
