import 'dart:async';
import 'package:aerion_dashboard/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:aerion_dashboard/features/onboarding/domain/entities/onboarding_item.dart';

// =========================================================================
// MODEL & ENUM
// =========================================================================

class AlertEntity {
  final String id; // Digunakan sebagai SN
  final String name; // Nama Cabang/Pusat
  final String address; // Alamat detail
  final AlertStatus status;

  AlertEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
  });
}

// Mengganti nama enum agar lebih sesuai dengan visual (Normal/Offline)
enum AlertStatus { all, normal, offline, maintenance }

// =========================================================================
// UTILITIES
// =========================================================================

// Utility untuk mendapatkan warna berdasarkan status
Color _statusColor(AlertStatus status) {
  switch (status) {
    case AlertStatus.normal:
      return Colors.green;
    case AlertStatus.offline:
      return Colors.red;
    case AlertStatus.maintenance:
      return Colors.orange;
    case AlertStatus.all:
      return Colors.blueGrey;
  }
}

// Utility untuk mendapatkan teks label status
String _statusLabel(AlertStatus status) {
  switch (status) {
    case AlertStatus.normal:
      return 'Normal';
    case AlertStatus.offline:
      return 'Offline';
    case AlertStatus.maintenance:
      return 'Maintenance';
    case AlertStatus.all:
      return 'All';
  }
}

// =========================================================================
// WIDGET UTAMA (SITES PAGE)
// =========================================================================

class AlertInformationPage extends StatefulWidget {
  final OnboardingItem? cluster;

  // Mengubah ke const, asalkan cluster dijamin menjadi objek konstan
  // atau diterima langsung dari GoRouter state.
  const AlertInformationPage({super.key, required this.cluster});

  @override
  State<AlertInformationPage> createState() => _AlertInformationPage();
}

class _AlertInformationPage extends State<AlertInformationPage> {
  late DateTime _currentDateTime;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  List<AlertEntity> _allSitess = [];
  List<AlertEntity> _filteredSitess = [];

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() => _currentDateTime = DateTime.now());
      }
    });
    _allSitess = _mockSitess();
    _filteredSitess = _allSitess;

    _searchController.addListener(_applySearchFilter);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.removeListener(_applySearchFilter);
    _searchController.dispose();
    super.dispose();
  }

  // Logika Filter
  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSitess = _allSitess.where((site) {
        return site.name.toLowerCase().contains(query) ||
            site.address.toLowerCase().contains(query) ||
            site.id.contains(query);
      }).toList();
    });
  }

  // MOCK DATA: Diperbarui agar sesuai dengan data di desain
  List<AlertEntity> _mockSitess() {
    return [
      AlertEntity(
        id: '534315325189731024',
        name: 'Plant A', // Diubah sesuai gambar
        address:
            'JL Gatot Subroto No. Kav. 52, Kuningan Barat, Jakarta Selatan',
        status: AlertStatus.normal,
      ),
      AlertEntity(
        id: '534315325189731024',
        name: 'Plant B', // Diubah sesuai gambar
        address:
            'JL Gatot Subroto No. Kav. 52, Kuningan Barat, Jakarta Selatan',
        status: AlertStatus.normal,
      ),
      AlertEntity(
        id: '534315325189731024',
        name: 'Plant C', // Diubah sesuai gambar
        address: 'JL Japati No. 1, Bandung',
        status: AlertStatus.offline,
      ),
      AlertEntity(
        id: '112233445566778899',
        name: 'Cabang Medan',
        address: 'JL Sisingamangaraja No. 5, Medan',
        status: AlertStatus.maintenance,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100], // Background terang
      appBar: CustomAppBar(
        title: dateFormat.format(_currentDateTime),
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
      body: _buildBody(),
    );
  }

  // --- Bagian Body (Mengandung Header Kustom dan List) ---
  Widget _buildBody() {
    final cluster = widget.cluster;

    // Default values
    final clusterImage =
        cluster?.logoAsset ?? 'assets/images/placeholder/placeholder.png';
    final clusterTitle = cluster?.title ?? 'Cluster Name';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header Konten (di bawah AppBar)
        Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          color: Colors.white, // Background putih untuk header
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(clusterImage, height: 28),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          clusterTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'GeisRegular',
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Logo/Nama Perusahaan (Komatsu KUI Cikarang)
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location installations',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        // 2. Daftar Lokasi (Expanded)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ListView.separated(
              itemCount: _filteredSitess.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final c = _filteredSitess[index];
                return SitesCard(sites: c);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET BARU: SitesCard (Diperbaiki agar sesuai desain)
// =========================================================================

class SitesCard extends StatelessWidget {
  final AlertEntity sites;

  const SitesCard({required this.sites, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Lebih bulat
      margin: EdgeInsets.zero,
      child: InkWell(
        hoverColor: Colors.white,
        onTap: () {
          // Navigasi ke Dashboard dan kirim data 'AlertEntity' yang dipilih
          context.go('/dashboard', extra: sites);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris 1: SN, Status Badge, dan Menu Opsi (...)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SN
                        Text(
                          'SN : ${sites.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Badge
                        _StatusBadge(status: sites.status),
                      ],
                    ),
                  ),
                  // Menu Opsi
                  InkWell(
                    onTap: () {
                      // Action untuk Menu
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Baris 2: Nama Lokasi (Tebal)
              Text(
                sites.name,
                style: const TextStyle(
                  fontSize: 18, // Ukuran lebih besar
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Baris 3: Alamat Detail (Abu-abu, kecil)
              Text(
                sites.address,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET BARU: _StatusBadge
// =========================================================================

class _StatusBadge extends StatelessWidget {
  final AlertStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = _statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Background transparan
        borderRadius: BorderRadius.circular(15), // Lebih oval
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
