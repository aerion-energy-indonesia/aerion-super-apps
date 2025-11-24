import 'package:flutter/material.dart';

// Definisi Warna
const Color _kPrimaryTextColor = Color(0xFF364153);
const Color _kAccentColor = Color(0xFF00305E);

/// Fungsi wrapper untuk menampilkan Bottom Sheet modal.
///
/// Penggunaan:
/// BottomSheet.show(
///   context,
///   title: 'Atur Parameter Grafik',
///   description: 'Pilih rentang waktu atau jenis data untuk analisis.',
///   content: Column(children: [/* Your custom widgets here */]),
/// );
class BottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? description,
    required Widget content,
    double initialHeightFraction = 0.5,
    bool isDismissible = true,
  }) {
    // Menghitung tinggi agar bottom sheet tidak lebih tinggi dari layar
    final screenHeight = MediaQuery.of(context).size.height;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled:
          true, // Memungkinkan Bottom Sheet menggunakan tinggi penuh
      isDismissible: isDismissible,
      backgroundColor:
          Colors.transparent, // Mengatur warna transparan di luar Card
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9, // Batasi tinggi hingga 90% layar
          ),
          child: _BottomSheetContent(
            title: title,
            description: description,
            content: content,
          ),
        );
      },
    );
  }
}

// =========================================================================
// WIDGET INTERNAL BOTTOM SHEET
// =========================================================================

class _BottomSheetContent extends StatelessWidget {
  final String title;
  final String? description;
  final Widget content;

  const _BottomSheetContent({
    required this.title,
    this.description,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Menggunakan Margin di atas untuk efek Card mengambang (opsional)
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle (Garis tarik)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _kPrimaryTextColor,
                        ),
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Tombol tutup (X)
                IconButton(
                  icon: const Icon(Icons.close, color: _kPrimaryTextColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 1, color: Colors.grey),

          // Konten Utama (Membuatnya scrollable secara internal)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
