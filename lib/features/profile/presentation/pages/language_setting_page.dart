import 'package:flutter/material.dart';

// Model sederhana untuk merepresentasikan opsi bahasa
class LanguageOption {
  final String name;
  final String code; // Contoh: 'en', 'zh', 'id'

  LanguageOption(this.name, this.code);
}

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  // Daftar bahasa yang tersedia
  final List<LanguageOption> availableLanguages = [
    LanguageOption('Chinese', 'zh'),
    LanguageOption('English', 'en'),
    LanguageOption('Indonesian', 'id'),
  ];

  // Simulasi bahasa yang sedang aktif
  String _selectedLanguageCode = 'en';

  // Warna yang digunakan
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentColor = Color(
    0xFFE57373,
  ); // Menggunakan warna oranye/merah yang sedikit lembut untuk status aktif (diasumsikan)

  // Fungsi untuk menangani pemilihan bahasa
  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguageCode = code;
    });

    // Di aplikasi nyata, di sini Anda akan memanggil Provider/Bloc
    // untuk menyimpan preferensi bahasa dan memuat ulang aplikasi/lokalisasi.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bahasa diubah menjadi ${_selectedLanguageCode.toUpperCase()}',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Language Setting',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: availableLanguages.map((lang) {
            bool isSelected = lang.code == _selectedLanguageCode;
            return _buildLanguageTile(
              context,
              language: lang.name,
              isSelected: isSelected,
              onTap: () => _selectLanguage(lang.code),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget pembantu untuk Language Tile
  Widget _buildLanguageTile(
    BuildContext context, {
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : Colors.transparent, // Border untuk bahasa aktif
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                language,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? accentColor : primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
