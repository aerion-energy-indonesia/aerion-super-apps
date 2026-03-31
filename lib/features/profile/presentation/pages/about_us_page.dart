import 'package:flutter/material.dart';
import 'package:aerion_dashboard/widgets/app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sesuaikan dengan background di desain
      appBar: CustomAppBar(
        title: 'About Us',
        backgroundColor: Colors.white,
        elevation: 0,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // Bagian 1: About the Aerion Super App
            // =========================================================
            const Text(
              'About the Aerion Super App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF364153),
              ),
            ),
            const SizedBox(height: 8),
            // Paragraf 1
            const Text(
              'At Aerion Energy, we believe that the future of energy is decentralized, smart, and environmentally friendly. Our Aerion Super App is designed to realize this vision a comprehensive application that connects users with their entire hybrid energy generation systems.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF364153),
              ),
            ),
            const SizedBox(height: 16),
            // Paragraf 2
            const Text(
              'We provide modern, intuitive, and accurate monitoring technology to help users understand energy flows, optimize system performance, and make smarter energy decisions.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF364153),
              ),
            ),

            const SizedBox(height: 32),

            // =========================================================
            // Bagian 2: Our Vision
            // =========================================================
            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF364153),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To build a connected, transparent, and accessible renewable energy ecosystem for everyone.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF364153),
              ),
            ),

            const SizedBox(height: 32),

            // =========================================================
            // Bagian 3: Our Focus (List)
            // =========================================================
            const Text(
              'Our Focus',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF364153),
              ),
            ),
            const SizedBox(height: 8),

            // List Item (Menggunakan Column dengan Padding untuk bullet point)
            _buildFocusItem('User convenience'),
            _buildFocusItem('Data accuracy'),
            _buildFocusItem('Energy transparency'),
            _buildFocusItem('Multisite management'),
            _buildFocusItem(
              'Connectivity with the latest generation inverters.',
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk item list (dengan bullet point)
  Widget _buildFocusItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0, right: 8.0),
            child: Icon(Icons.circle, size: 5, color: Color(0xFF364153)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF364153),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
