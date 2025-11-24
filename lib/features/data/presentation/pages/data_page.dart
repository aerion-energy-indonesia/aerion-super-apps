import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Model untuk Data Waktu (Kolom Kiri)
class TimeLog {
  final String time;
  final String detailId; // Kunci untuk mengambil detail data

  TimeLog({required this.time, required this.detailId});
}

// Model untuk Data Rincian (Kolom Kanan)
class DataDetail {
  final String name;
  final String value;
  final String unit; // Misalnya: V, Hz, W, A

  DataDetail({required this.name, required this.value, required this.unit});
}

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color selectedTimeColor = Color(
    0xFFF0F4F8,
  ); // Warna latar belakang item waktu yang dipilih

  // Data Mock
  late List<TimeLog> _timeLogs;
  late List<DataDetail> _currentDetails;
  String _selectedDetailId = 'log_1';

  @override
  void initState() {
    super.initState();
    _timeLogs = _mockTimeLogs();
    _currentDetails = _getDetails(_selectedDetailId);
  }

  // --- Mock Data ---

  List<TimeLog> _mockTimeLogs() {
    return [
      TimeLog(time: '13:06', detailId: 'log_1'),
      TimeLog(time: '12:58:12', detailId: 'log_2'),
      TimeLog(time: '12:52:31', detailId: 'log_3'),
      TimeLog(time: '12:49:51', detailId: 'log_4'),
      TimeLog(time: '12:44:52', detailId: 'log_5'),
      TimeLog(time: '12:41:09', detailId: 'log_6'),
      TimeLog(time: '12:37:17', detailId: 'log_7'),
      TimeLog(time: '12:33:10', detailId: 'log_8'),
      TimeLog(time: '12:28:06', detailId: 'log_9'),
      TimeLog(time: '12:23:21', detailId: 'log_10'),
      TimeLog(time: '12:21:10', detailId: 'log_11'),
      TimeLog(time: '12:13:12', detailId: 'log_12'),
      TimeLog(time: '12:08:44', detailId: 'log_13'),
    ];
  }

  List<DataDetail> _getDetails(String detailId) {
    // Data mock yang kompleks (simulasi data yang berbeda berdasarkan waktu/detailId)
    if (detailId == 'log_1') {
      return [
        DataDetail(name: 'Working State', value: 'Invert', unit: 'Mode'),
        DataDetail(name: 'AC Input Voltage', value: '231.5', unit: 'V'),
        DataDetail(name: 'AC Input Frequency', value: '49.9', unit: 'Hz'),
        DataDetail(name: 'PV Input Voltage', value: '402.3', unit: 'V'),
        DataDetail(name: 'PV Input Power', value: '4506', unit: 'W'),
        DataDetail(name: 'Battery Voltage', value: '51.6', unit: 'V'),
        DataDetail(name: 'Battery Capacity', value: '100', unit: '%'),
        DataDetail(name: 'Battery Charging Current', value: '81', unit: 'A'),
        DataDetail(name: 'Battery Discharge Current', value: '0', unit: 'A'),
        DataDetail(name: 'Output Voltage', value: '230.1', unit: 'V'),
        DataDetail(name: 'Output Frequency', value: '49.9', unit: 'Hz'),
        DataDetail(name: 'Apparent Power', value: '4486', unit: 'VA'),
      ];
    }
    // Jika waktu berbeda, data harus berbeda. Ini hanya simulasi.
    return [
      DataDetail(name: 'Working State', value: 'Standby', unit: 'Mode'),
      DataDetail(name: 'AC Input Voltage', value: '0', unit: 'V'),
      DataDetail(name: 'PV Input Voltage', value: '350.5', unit: 'V'),
      DataDetail(name: 'Battery Capacity', value: '85', unit: '%'),
    ];
  }

  // --- UI Builder ---

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
              '24 November 2025',
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

  // Widget Dropdown Tanggal & Waktu Navigasi
  Widget _buildDateNavigator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Panah Kiri
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () {},
          ),
          // Dropdown Tanggal & Waktu
          Expanded(
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '01 Sept 2025 - 12:35:12 PM',
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
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
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Widget Kolom Kiri: Time Logs
  Widget _buildTimeLogColumn(BuildContext context) {
    return SizedBox(
      width: 100, // Lebar tetap untuk kolom waktu
      child: ListView.builder(
        // Catatan: Jika ingin scroll bersama, gunakan controller
        itemCount: _timeLogs.length,
        itemBuilder: (context, index) {
          final log = _timeLogs[index];
          final isSelected = log.detailId == _selectedDetailId;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedDetailId = log.detailId;
                _currentDetails = _getDetails(log.detailId);
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: isSelected ? selectedTimeColor : Colors.white,
                // Border kanan tebal untuk penanda aktif
                border: Border(
                  right: BorderSide(
                    color: isSelected ? accentRed : Colors.transparent,
                    width: 4.0,
                  ),
                ),
              ),
              child: Text(
                log.time.split(' ')[0], // Hanya tampilkan waktu (misal 13:06)
                style: TextStyle(
                  color: isSelected ? accentRed : primaryTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget Kolom Kanan: Data Rincian
  Widget _buildDataDetailsColumn(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 16.0,
        ), // Padding kiri untuk memisahkan
        child: Column(
          children: [
            // Header Kolom Kanan
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Data Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Daftar Rincian
            Expanded(
              child: ListView.builder(
                itemCount: _currentDetails.length,
                itemBuilder: (context, index) {
                  final detail = _currentDetails[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            detail.name,
                            style: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${detail.value}${detail.unit}',
                            style: TextStyle(
                              color: accentRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

          // Judul Data Details
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 16.0, bottom: 8.0),
            child: Text(
              'Data Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
          ),

          // Navigasi Tanggal & Waktu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildDateNavigator(),
          ),

          // Area Tabel Utama (Flex untuk sisa ruang)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    // Kolom Kiri: Time Logs
                    _buildTimeLogColumn(context),

                    // Kolom Kanan: Data Details
                    _buildDataDetailsColumn(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
