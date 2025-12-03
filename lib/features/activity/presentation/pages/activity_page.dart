import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aerion_dashboard/themes/app_colors.dart';
// import 'package:aerion_dashboard/widgets/reusable_bar_chart.dart';
// import 'package:aerion_dashboard/widgets/reusable_pie_chart.dart';
// import 'package:aerion_dashboard/widgets/reusable_line_chart.dart';
import 'package:aerion_dashboard/widgets/bottom_sheet.dart';
import 'package:aerion_dashboard/widgets/time_filter_widgets.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late DateTime _currentDateTime;
  Timer? _timer;
  String _activeTab = 'Day'; // State untuk melacak tab yang aktif

  // Warna dan Konstanta
  static const Color primaryTextColor = AppColors.textPrimary;
  static const Color secondaryTextColor = AppColors.textOnSecondary;
  static const Color primaryBackgroundColor = AppColors.textPrimary;
  static const Color accentBlue = Color(
    0xFF3B82F6,
  ); // Warna biru untuk generation
  static const Color accentRed = Color(0xFFEF4444); // Warna merah untuk usage

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() => _currentDateTime = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
    final dateFormat = DateFormat('d MMMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // IMPLEMENTASI CUSTOM APP BAR
      appBar: CustomAppBar(
        title: dateFormat.format(
          _currentDateTime,
        ), // Menggunakan tanggal sebagai judul
        showBackButton: false,
        trailing: IconButton(
          icon: SvgPicture.asset('assets/svg/settings.svg'),
          onPressed: () {
            context.go('/settings');
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
          child: Container(
            color: Colors.white,
            child: Padding(
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
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primaryTextColor,
                      fontFamily: 'GeistSemiBold',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Total Power',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor,
                          fontFamily: 'GeistRegular',
                        ),
                      ),
                      Text(
                        ' 119.816',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: primaryTextColor,
                          fontFamily: 'GeistSemiBold',
                        ),
                      ),
                      Text(
                        ' kWh',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor,
                          fontFamily: 'GeistRegular',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTimeTabs(),
                  _buildDateNavigatorSection(context),
                  _buildChartPlaceholder(context),
                  _buildChartLegend(),
                  const SizedBox(height: 16),
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  _buildLogTable(logData),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['Day', 'Month', 'Year'].map((label) {
          bool isActive = label == _activeTab; // Gunakan _activeTab
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _activeTab =
                        label; // Perbarui _activeTab saat tombol ditekan
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: isActive
                      ? primaryBackgroundColor.withOpacity(0.8)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    // Menggunakan RoundedRectangleBorder
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GeistRegular',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateNavigatorSection(BuildContext context) {
    // Simulasi state
    final String currentDisplay = '01 Sept 2025 - 12:35:12 PM';

    return DateNavigator(
      type: TimeFilterType.day,
      currentValue: currentDisplay,
      onBackward: () => print('Backward Nav clicked'),
      onForward: () => print('Forward Nav clicked'),
      onDropdownTap: () {
        // Tampilkan Bottom Sheet Filter Hari
        MyBottomSheet.show(
          context,
          title: 'Filter Day', // Judul dari desain: Filter Day/Month/Year
          content: DateFilterModal(
            type: TimeFilterType.day,
            onConfirm: (selectedValue) {
              print('Date Filter Confirmed: $selectedValue');
            },
          ),
          // Karena DateFilterModal sudah memiliki ScrollView internal,
          // kita bisa atur tinggi yang sesuai di sini.
        );
      },
    );
  }

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
          }),
        ],
      ),
    );
  }
}
