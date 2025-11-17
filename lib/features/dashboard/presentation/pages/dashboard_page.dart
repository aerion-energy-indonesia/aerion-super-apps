import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/summary_card.dart';
import '../widgets/recent_activity.dart';

// Definisi Model data (placeholder)
class DashboardSummary {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  DashboardSummary({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Data mock untuk kartu ringkasan
  List<DashboardSummary> _getSummaries() {
    return [
      DashboardSummary(
        title: 'Total Cabang',
        value: 125,
        icon: Icons.business,
        color: Colors.blue,
      ),
      DashboardSummary(
        title: 'Status Normal',
        value: 102,
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
      DashboardSummary(
        title: 'Offline',
        value: 15,
        icon: Icons.offline_bolt,
        color: Colors.red,
      ),
      DashboardSummary(
        title: 'Maintenance',
        value: 8,
        icon: Icons.build_circle_outlined,
        color: Colors.orange,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {
              context.go('/dashboard/profile');
            },
          ),
        ],
      ),
      // Menggunakan SingleChildScrollView untuk responsivitas
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ringkasan Status Jaringan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Bagian Kartu Ringkasan (Responsive Grid)
            _buildSummaryGrid(context, _getSummaries()),

            const SizedBox(height: 30),

            // Bagian Aktivitas Terbaru
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const RecentActivity(),
          ],
        ),
      ),
    );
  }

  // Metode untuk membangun GridView yang responsif
  Widget _buildSummaryGrid(
    BuildContext context,
    List<DashboardSummary> summaries,
  ) {
    // Hitung lebar layar untuk menentukan jumlah kolom
    final screenWidth = MediaQuery.of(context).size.width;
    // Tentukan jumlah kolom: 2 untuk mobile, 3 atau 4 untuk tablet/desktop
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return GridView.builder(
      shrinkWrap:
          true, // Wajib diatur jika berada di dalam SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Nonaktifkan scroll GridView
      itemCount: summaries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2, // Aspek rasio kartu (tinggi/lebar)
      ),
      itemBuilder: (context, index) {
        return SummaryCard(summary: summaries[index]);
      },
    );
  }
}
