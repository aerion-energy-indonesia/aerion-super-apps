import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// =========================================================================
// MODEL & ENUM (Tidak Berubah Signifikan, hanya penamaan status)
// =========================================================================

class Cluster {
  final String id; // Digunakan sebagai SN
  final String name; // Nama Cabang/Pusat
  final String address; // Alamat detail
  final ClusterStatus status;

  Cluster({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
  });
}

// Mengganti nama enum agar lebih sesuai dengan visual (Normal/Offline)
enum ClusterStatus { all, normal, offline, maintenance }

// =========================================================================
// UTILITIES
// =========================================================================

// Utility untuk mendapatkan warna berdasarkan status
Color _statusColor(ClusterStatus status) {
  switch (status) {
    case ClusterStatus.normal:
      return Colors.green;
    case ClusterStatus.offline:
      return Colors.red;
    case ClusterStatus.maintenance:
      return Colors.orange;
    case ClusterStatus.all:
      return Colors.blueGrey;
  }
}

// Utility untuk mendapatkan teks label status
String _statusLabel(ClusterStatus status) {
  switch (status) {
    case ClusterStatus.normal:
      return 'Normal';
    case ClusterStatus.offline:
      return 'Offline';
    case ClusterStatus.maintenance:
      return 'Maintenance';
    case ClusterStatus.all:
      return 'All';
  }
}

// =========================================================================
// WIDGET UTAMA
// =========================================================================

class ClusterPage extends StatefulWidget {
  const ClusterPage({super.key});

  @override
  State<ClusterPage> createState() => _ClusterPageState();
}

class _ClusterPageState extends State<ClusterPage> {
  // Menghapus _searchController dan filter logic karena tidak ada di desain yang diberikan.
  List<Cluster> _allClusters = [];

  @override
  void initState() {
    super.initState();
    // Mengganti _allClusters dengan data mock baru yang lebih detail
    _allClusters = _mockClusters();
  }

  // Menghapus _applyFilters, _setFilter, _clearSearch, dan _buildFilterMenu
  // karena tidak relevan dengan desain statis yang diminta.

  @override
  void dispose() {
    super.dispose();
  }

  // MOCK DATA: Diperbarui agar sesuai dengan data di desain
  List<Cluster> _mockClusters() {
    return [
      Cluster(
        id: '534315325189731024',
        name: 'Kantor Pusat Jakarta',
        address:
            'JL Gatot Subroto No. Kav. 52, Kuningan Barat, Jakarta Selatan',
        status: ClusterStatus.normal,
      ),
      Cluster(
        id: '1362426426452321',
        name: 'Kantor Pusat Bandung',
        address: 'JL Japati No. 1, Bandung',
        status: ClusterStatus.offline,
      ),
      Cluster(
        id: '998877665544332211',
        name: 'Cabang Surabaya',
        address: 'JL A Yani No. 100, Surabaya',
        status: ClusterStatus.maintenance,
      ),
      Cluster(
        id: '112233445566778899',
        name: 'Cabang Medan',
        address: 'JL Sisingamangaraja No. 5, Medan',
        status: ClusterStatus.normal,
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
          context.pop();
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
            itemCount: _allClusters.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = _allClusters[index];
              return ClusterCard(cluster: c);
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
// WIDGET BARU: ClusterCard (Menggantikan Card/ListTile default)
// =========================================================================

class ClusterCard extends StatelessWidget {
  final Cluster cluster;

  const ClusterCard({required this.cluster, super.key});

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
          //       'Detail ${cluster.name} (${_statusLabel(cluster.status)})',
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
                    'SN: ${cluster.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _StatusBadge(status: cluster.status),
                ],
              ),
              const SizedBox(height: 8),

              // Nama Lokasi (Baris 2)
              Text(
                cluster.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Alamat Detail (Baris 3)
              Text(
                cluster.address,
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
  final ClusterStatus status;

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
