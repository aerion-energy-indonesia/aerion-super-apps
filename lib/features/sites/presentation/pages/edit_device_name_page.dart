import 'package:flutter/material.dart';

class EditDeviceNamePage extends StatefulWidget {
  // Argument yang diharapkan dari router
  final String deviceId;
  final String currentDeviceName;

  const EditDeviceNamePage({
    super.key,
    required this.deviceId,
    required this.currentDeviceName,
  });

  @override
  State<EditDeviceNamePage> createState() => _EditDeviceNamePageState();
}

class _EditDeviceNamePageState extends State<EditDeviceNamePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  // Warna dan Konstanta
  static const Color primaryTextColor = Color(0xFF364153);
  static const Color accentColor = Color(0xFF00305E);
  static const Color buttonColor = Color(0xFF364153); // Warna tombol gelap
  static const int maxNameLength = 20;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nama perangkat saat ini
    _nameController = TextEditingController(text: widget.currentDeviceName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani pembaruan nama perangkat
  void _handleUpdateDeviceName() async {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();

      if (newName == widget.currentDeviceName) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama perangkat tidak berubah.'),
            backgroundColor: Colors.blueGrey,
          ),
        );
        return;
      }

      // 1. Simulasikan pemanggilan API/use case untuk update nama
      try {
        // Contoh Logika Nyata:
        // await useCase.execute(widget.deviceId, newName);

        // Simulasikan berhasil:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nama perangkat berhasil diubah menjadi: $newName'),
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
            content: Text('Gagal mengubah nama perangkat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Edit Name Device',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // Label Input
              // =========================================================
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Name Device',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                    fontSize: 15,
                  ),
                ),
              ),

              // =========================================================
              // Input Field
              // =========================================================
              TextFormField(
                controller: _nameController,
                maxLength: maxNameLength,
                style: const TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Plant A', // Contoh default placeholder
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
                  // Menghilangkan counter teks di bawah
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama perangkat tidak boleh kosong';
                  }
                  if (value.length > maxNameLength) {
                    return 'Nama perangkat maksimal $maxNameLength karakter';
                  }
                  // Regex untuk mengecualikan emoji/karakter tidak valid (simulasi)
                  if (RegExp(r'[^\w\s-]').hasMatch(value)) {
                    return 'Tidak boleh mengandung karakter atau emoji yang tidak valid';
                  }
                  return null;
                },
              ),

              // =========================================================
              // Deskripsi/Hint
              // =========================================================
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 40.0),
                child: Text(
                  'Please set 1-20 characters, excluding emojis or invalid characters',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              // =========================================================
              // Tombol Simpan
              // =========================================================
              ElevatedButton(
                onPressed: _handleUpdateDeviceName,
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
