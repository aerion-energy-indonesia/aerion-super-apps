import 'package:aerion_dashboard/widgets/app_bar.dart';
import 'package:flutter/material.dart';

// Asumsi rute navigasi lain sudah terdefinisi di GoRouter
// import 'package:go_router/go_router.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna yang sering digunakan
    const Color primaryTextColor = Color(0xFF364153);
    const Color accentColor = Color(0xFF00305E); // Warna biru tua dari About Us
    const Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Background lebih terang
      appBar: CustomAppBar(
        title: 'Help',
        backgroundColor: cardColor,
        elevation: 0,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =========================================================
            // Bagian 1: Pesan Pembuka (Call-to-Action)
            // =========================================================
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Need help? Find a quick guide to add devices, set up your network, and read energy reports.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: primaryTextColor,
                  fontFamily: 'GeistRegular',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // Bagian 2: Daftar Opsi Bantuan (List Tiles)
            // =========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildHelpOption(
                    context,
                    title: 'Basic Guide',
                    onTap: () {
                      // context.push('/help/guide');
                      _showSnackbar(context, 'Navigating to Basic Guide');
                    },
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildHelpOption(
                    context,
                    title: 'FAQ',
                    onTap: () {
                      // context.push('/help/faq');
                      _showSnackbar(context, 'Navigating to FAQ');
                    },
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildHelpOption(
                    context,
                    title: 'Contact Us',
                    onTap: () {
                      // context.push('/help/contact');
                      _showSnackbar(context, 'Navigating to Contact Us');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // Bagian 3: Pesan Komitmen (Penutup)
            // =========================================================
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accentColor.withOpacity(0.1)),
              ),
              child: const Text(
                'We are committed to providing fast, clear support to help you optimize your HRES system.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: primaryTextColor,
                  fontFamily: 'GeistRegular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk ListTile
  Widget _buildHelpOption(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF364153),
          fontWeight: FontWeight.w500,
          fontFamily: 'GeistRegular',
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  // Fungsi pengganti Snackbar karena tidak ada ScaffoldMessenger di Stateles widget tanpa context dari GoRouter
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
