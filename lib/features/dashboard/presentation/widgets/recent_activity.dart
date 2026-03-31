import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  // Data mock aktivitas terbaru
  List<Map<String, dynamic>> _getActivities() {
    return [
      {
        'title': 'CL-002: Offline',
        'subtitle': 'Kantor Bandung mengalami gangguan. Perlu pengecekan.',
        'icon': Icons.flash_on,
        'color': Colors.red,
      },
      {
        'title': 'CL-005: Normal',
        'subtitle': 'Cabang Berlin kembali aktif setelah maintenance.',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'System Update',
        'subtitle': 'Pembaruan sistem terjadwal dimulai dalam 1 jam.',
        'icon': Icons.settings_suggest,
        'color': Colors.blue,
      },
      {
        'title': 'CL-006: Maintenance',
        'subtitle': 'Jaringan Tokyo dijadwalkan maintenance sore ini.',
        'icon': Icons.build,
        'color': Colors.orange,
      },
      {
        'title': 'CL-001: Normal',
        'subtitle': 'Semua sistem di New York berfungsi normal.',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activities = _getActivities();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Agar tidak bentrok scroll dengan SingleChildScrollView
        itemCount: activities.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
            ),
            title: Text(
              activity['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              activity['subtitle'] as String,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              // Aksi saat item aktivitas diklik
            },
          );
        },
      ),
    );
  }
}
