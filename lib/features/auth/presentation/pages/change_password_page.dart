import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Asumsi: Anda memiliki AuthNotifier dan AuthState di path berikut
import 'package:aerion_dashboard/features/auth/presentation/providers/auth_notifier.dart';
// Asumsi: Anda memiliki komponenFormField.dart atau form_field.dart
// import '../widgets/form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _originalPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State untuk visibilitas password
  bool _isOriginalPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentColor = Color(0xFF00305E);
  static const Color buttonColor = Color(0xFF364153); // Warna tombol gelap

  @override
  void dispose() {
    _originalPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      // 1. Ambil AuthNotifier
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

      // 2. Simulasi pemanggilan fungsi ganti password
      try {
        // Logika nyata:
        // a. Re-authenticate user (perlu email dan original password)
        // b. Panggil fungsi updatePassword(newPassword)

        // Simulasikan berhasil:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password berhasil diubah. Anda akan diarahkan kembali.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman sebelumnya setelah sukses
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Tangani error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah password: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Widget pengganti TextFormField (menggunakan standard Flutter untuk kemudahan)
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
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
          obscureText: !isVisible,
          style: const TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
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
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari AuthNotifier untuk header
    final user = context.watch<AuthNotifier>().state.user;

    // Default user data jika belum ada
    final String username = user?.username ?? 'Pengguna Tidak Dikenal';
    final String email = user?.email ?? 'email@example.com';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Change Password',
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
              // Header Profil
              // =========================================================
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =========================================================
              // Input: Password Original
              // =========================================================
              _buildPasswordField(
                label: 'Password Original',
                controller: _originalPasswordController,
                hintText: 'Please enter the original password',
                isVisible: _isOriginalPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isOriginalPasswordVisible = !_isOriginalPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password original harus diisi';
                  }
                  // Di aplikasi nyata, Anda perlu memverifikasi password ini sebelum melanjutkan
                  return null;
                },
              ),

              // =========================================================
              // Input: New Password
              // =========================================================
              _buildPasswordField(
                label: 'New Password',
                controller: _newPasswordController,
                hintText: 'Please enter a new password',
                isVisible: _isNewPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru harus diisi';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),

              // =========================================================
              // Input: Confirm New Password
              // =========================================================
              _buildPasswordField(
                label: 'New Password (Confirm)',
                controller: _confirmPasswordController,
                hintText: 'Please re-enter a new password',
                isVisible: _isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password harus diisi';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // =========================================================
              // Tombol Simpan
              // =========================================================
              ElevatedButton(
                onPressed: _handleChangePassword,
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
