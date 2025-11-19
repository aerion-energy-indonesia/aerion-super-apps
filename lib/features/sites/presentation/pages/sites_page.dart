import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// =========================================================================
// MODEL & ENUM (Tidak Berubah Signifikan, hanya penamaan status)
// =========================================================================

class Sites {
  final String id; // Digunakan sebagai SN
  final String name; // Nama Cabang/Pusat
  final String address; // Alamat detail
  final SitesStatus status;

  Sites({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
  });
}

// Mengganti nama enum agar lebih sesuai dengan visual (Normal/Offline)
enum SitesStatus { all, normal, offline, maintenance }

// =========================================================================
// UTILITIES
// =========================================================================

// Utility untuk mendapatkan warna berdasarkan status
Color _statusColor(SitesStatus status) {
  switch (status) {
    case SitesStatus.normal:
      return Colors.green;
    case SitesStatus.offline:
      return Colors.red;
    case SitesStatus.maintenance:
      return Colors.orange;
    case SitesStatus.all:
      return Colors.blueGrey;
  }
}

// Utility untuk mendapatkan teks label status
String _statusLabel(SitesStatus status) {
  switch (status) {
    case SitesStatus.normal:
      return 'Normal';
    case SitesStatus.offline:
      return 'Offline';
    case SitesStatus.maintenance:
      return 'Maintenance';
    case SitesStatus.all:
      return 'All';
  }
}

// =========================================================================
// WIDGET UTAMA
// =========================================================================

class SitesPage extends StatefulWidget {
  const SitesPage({super.key});

  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  // Menghapus _searchController dan filter logic karena tidak ada di desain yang diberikan.
  List<Sites> _allSitess = [];

  @override
  void initState() {
    super.initState();
    // Mengganti _allSitess dengan data mock baru yang lebih detail
    _allSitess = _mockSitess();
  }

  // Menghapus _applyFilters, _setFilter, _clearSearch, dan _buildFilterMenu
  // karena tidak relevan dengan desain statis yang diminta.

  @override
  void dispose() {
    super.dispose();
  }

  // MOCK DATA: Diperbarui agar sesuai dengan data di desain
  List<Sites> _mockSitess() {
    return [
      Sites(
        id: '534315325189731024',
        name: 'Kantor Pusat Jakarta',
        address:
            'JL Gatot Subroto No. Kav. 52, Kuningan Barat, Jakarta Selatan',
        status: SitesStatus.normal,
      ),
      Sites(
        id: '1362426426452321',
        name: 'Kantor Pusat Bandung',
        address: 'JL Japati No. 1, Bandung',
        status: SitesStatus.offline,
      ),
      Sites(
        id: '998877665544332211',
        name: 'Cabang Surabaya',
        address: 'JL A Yani No. 100, Surabaya',
        status: SitesStatus.maintenance,
      ),
      Sites(
        id: '112233445566778899',
        name: 'Cabang Medan',
        address: 'JL Sisingamangaraja No. 5, Medan',
        status: SitesStatus.normal,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background terang
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(), // Menambahkan BNav placeholder
    );
  }

  // --- Bagian AppBar (Sesuai Desain Gambar) ---
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            context.pop();
          } else {
            context.go('/onboarding');
          }
        },
      ),
      title: const Text(
        'PT. Telkomsel', // Menggunakan nama perusahaan sebagai judul
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                'Telkomsel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Bagian Body (List Cabang) ---
  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Cabang List',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _allSitess.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = _allSitess[index];
              return SitesCard(sites: c);
            },
          ),
        ),
      ],
    );
  }

  // --- Placeholder Bottom Navigation Bar ---
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      elevation: 4,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.desktop_windows),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning_amber),
          label: 'Alarm',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}

// =========================================================================
// WIDGET BARU: SitesCard (Menggantikan Card/ListTile default)
// =========================================================================

class SitesCard extends StatelessWidget {
  final Sites sites;

  const SitesCard({required this.sites, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.go('/dashboard');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //       'Detail ${Sites.name} (${_statusLabel(Sites.status)})',
          //     ),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SN dan Status Badge (Baris 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SN: ${sites.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _StatusBadge(status: sites.status),
                ],
              ),
              const SizedBox(height: 8),

              // Nama Lokasi (Baris 2)
              Text(
                sites.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Alamat Detail (Baris 3)
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
  final SitesStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = _statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Background transparan
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
