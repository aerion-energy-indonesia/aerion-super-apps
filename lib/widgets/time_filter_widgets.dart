import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Definisi Warna
const Color _kPrimaryTextColor = Color(0xFF364153);
const Color _kAccentColor = Color(0xFF00305E);
const Color _kButtonColor = Color(0xFF364153);

// =============================================================================
// 1. DATE NAVIGATOR WIDGET (Digunakan di Activity/Analysis Page)
// =============================================================================

/// Widget navigasi waktu yang menampilkan panah kiri/kanan dan dropdown tengah.
/// Jenis tampilan disesuaikan berdasarkan 'TimeFilterType'.
class DateNavigator extends StatelessWidget {
  final TimeFilterType type;
  final String currentValue;
  final VoidCallback onBackward;
  final VoidCallback onForward;
  final VoidCallback onDropdownTap; // Aksi saat dropdown ditekan

  const DateNavigator({
    super.key,
    required this.type,
    required this.currentValue,
    required this.onBackward,
    required this.onForward,
    required this.onDropdownTap,
  });

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: _kPrimaryTextColor,
            ),
            onPressed: onBackward,
          ),

          // Dropdown Tengah
          Expanded(
            child: InkWell(
              onTap: onDropdownTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentValue,
                      style: const TextStyle(
                        color: _kPrimaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: _kPrimaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Panah Kanan
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: _kPrimaryTextColor,
            ),
            onPressed: onForward,
          ),
        ],
      ),
    );
  }
}

// Enum untuk menentukan jenis filter
enum TimeFilterType { day, month, year }

// =============================================================================
// 2. DATE FILTER MODAL (Bottom Sheet Content)
// =============================================================================

/// Widget Bottom Sheet yang menampilkan opsi filter tanggal berdasarkan Hari, Bulan, atau Tahun.
class DateFilterModal extends StatelessWidget {
  final TimeFilterType type;
  final Function(dynamic selectedValue) onConfirm;

  const DateFilterModal({
    super.key,
    required this.type,
    required this.onConfirm,
  });

  // Data Mock untuk List Filter
  List<dynamic> _getMockData() {
    switch (type) {
      case TimeFilterType.day:
        return List<int>.generate(30, (i) => i + 1);
      case TimeFilterType.month:
        return [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember',
        ];
      case TimeFilterType.year:
        return [2021, 2022, 2023, 2024, 2025];
    }
  }

  // Widget untuk membangun kolom header (Date/Month/Year)
  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: _kPrimaryTextColor,
        fontSize: 16,
      ),
    );
  }

  // Widget untuk membangun nilai data dalam list
  Widget _buildDataItem(dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulasi data yang dipilih secara default
    final data = _getMockData();

    // Asumsi: Kita hanya memilih 2025 sebagai tahun default,
    // dan Mei sebagai bulan default untuk menampilkan struktur.

    // Struktur Konten Utama Grid
    Widget content;

    if (type == TimeFilterType.day) {
      // Filter Day: Kolom Date, Month, Year
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader('Date'),
              _buildHeader('Month'),
              _buildHeader('Year'),
            ],
          ),
          const Divider(),
          // Data Simulasi (Hanya contoh layout)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: data.take(5).map((d) => _buildDataItem(d)).toList(),
              ),
              Column(
                children: [
                  'Mei',
                  'Juni',
                  'Juli',
                  'Agustus',
                  'September',
                ].map((d) => _buildDataItem(d)).toList(),
              ),
              Column(
                children: [
                  2021,
                  2022,
                  2023,
                  2024,
                  2025,
                ].map((d) => _buildDataItem(d)).toList(),
              ),
            ],
          ),
        ],
      );
    } else if (type == TimeFilterType.month) {
      // Filter Month: Kolom Month, Year
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildHeader('Month'), _buildHeader('Year')],
          ),
          const Divider(),
          // Data Simulasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: data.take(5).map((d) => _buildDataItem(d)).toList(),
              ),
              Column(
                children: [
                  2021,
                  2022,
                  2023,
                  2024,
                  2025,
                ].map((d) => _buildDataItem(d)).toList(),
              ),
            ],
          ),
        ],
      );
    } else {
      // Filter Year: Kolom Year
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader('Year'),
          const Divider(),
          // Data Simulasi
          Column(children: data.map((d) => _buildDataItem(d)).toList()),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Konten List/Grid
          content,

          const SizedBox(height: 32),

          // Tombol Konfirmasi
          ElevatedButton(
            onPressed: () {
              // Di sini Anda akan menangkap nilai yang dipilih
              onConfirm('Simulasi nilai konfirmasi');
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
