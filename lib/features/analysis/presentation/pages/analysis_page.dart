import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart'; // Import Custom AppBar
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late DateTime _currentDateTime;
  Timer? _timer;

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentGreen = Color(
    0xFF10B981,
  ); // Warna hijau untuk grafik

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
            Expanded(
              child: Center(
                child: Container(
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
    final dateFormat = DateFormat('d MMMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // IMPLEMENTASI CUSTOM APP BAR
      appBar: CustomAppBar(
        title: dateFormat.format(_currentDateTime),
        trailing: IconButton(
          icon: SvgPicture.asset('assets/svg/settings.svg'),
          onPressed: () {
            context.go('/settings');
          },
        ),
        showBackButton: false,
        // showBackButton defaultnya true
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Navigasi & Tombol Parameter (Diletakkan di body agar bisa di-scroll)
              _buildNavigatorAndParameters(context),

              const SizedBox(height: 16),

              // Area Grafik
              _buildChartPlaceholder(),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
