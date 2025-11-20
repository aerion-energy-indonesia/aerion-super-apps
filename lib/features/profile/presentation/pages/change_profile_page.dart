import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Asumsi: Anda memiliki AuthNotifier dan AuthState di path berikut
import 'package:aerion_dashboard/features/auth/presentation/providers/auth_notifier.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentColor = Color(0xFF00305E);
  static const Color buttonColor = Color(0xFF364153); // Warna tombol gelap

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data pengguna saat ini
    final user = Provider.of<AuthNotifier>(context, listen: false).state.user;
    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      // 1. Ambil AuthNotifier
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

      // Data yang akan diupdate
      final String newName = _nameController.text.trim();
      final String newEmail = _emailController.text.trim();

      // Cek apakah ada perubahan
      if (newName == authNotifier.state.user?.username &&
          newEmail == authNotifier.state.user?.email) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada perubahan yang dilakukan.'),
            backgroundColor: Colors.blueGrey,
          ),
        );
        return;
      }

      // 2. Simulasi pemanggilan fungsi update profil
      try {
        // Logika nyata:
        // a. Panggil use case untuk update profil (nama)
        // b. Jika email diubah, perlu proses verifikasi ulang email, tapi di sini kita simulasikan langsung

        // Simulasikan berhasil:
        // authNotifier.updateUserProfile(
        //   newName,
        //   newEmail,
        // ); // Memperbarui state lokal (simulasi)

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya setelah sukses
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Tangani error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Widget pengganti TextFormField
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
              fontSize: 15,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          readOnly: !isEditable, // Baca-saja jika tidak dapat diedit
          style: TextStyle(
            color: isEditable ? primaryTextColor : Colors.grey[600],
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: accentColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              // Gaya saat disabled
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Personal Profile',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =========================================================
              // Foto Profil & Unggah
              // =========================================================
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: buttonColor,
                      child: Icon(Icons.person, color: Colors.white, size: 60),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Simulasi fungsi unggah foto
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Simulasi: Fungsi Upload Foto dipanggil.',
                            ),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      },
                      child: const Text(
                        'Upload Foto',
                        style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================================================
              // Input: Name
              // =========================================================
              _buildTextField(
                label: 'Name',
                controller: _nameController,
                isEditable: true, // Nama bisa diubah
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),

              // =========================================================
              // Input: Email (Diasumsikan tidak bisa diubah langsung)
              // =========================================================
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                isEditable: false, // Email biasanya tidak diubah di sini
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // =========================================================
              // Tombol Simpan
              // =========================================================
              ElevatedButton(
                onPressed: _handleUpdateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
