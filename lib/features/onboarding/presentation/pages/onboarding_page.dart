import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:aerion_dashboard/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:aerion_dashboard/app_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    // load items when widget appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadItems();
    });
  }

  Widget _buildItemCard(OnboardingItem item) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 0.1),
      ),
      child: InkWell(
        onTap: () {
          // Logika navigasi atau aksi saat item diklik
          context.go('/cluster');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                // Menggunakan Icon dari CardItem
                child: Image.asset(item.logoAsset, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF364153),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveList(
    BuildContext context,
    List<OnboardingItem> items,
  ) {
    // Tentukan lebar layar saat ini
    final screenWidth = MediaQuery.of(context).size.width;
    // Tentukan breakpoint (600px adalah breakpoint umum)
    const breakpoint = 600.0;

    // Jumlah kolom: 1 untuk layar kecil, 3 untuk layar besar
    final int crossAxisCount = screenWidth > breakpoint ? 3 : 1;

    if (items.isEmpty && !context.watch<AppState>().loading) {
      return const Center(child: Text('Tidak ada item yang tersedia.'));
    }

    // Widget builder utama.
    if (screenWidth > breakpoint) {
      // Tampilan Grid untuk layar besar
      return GridView.builder(
        // Karena diletakkan di dalam SingleChildScrollView, kita harus:
        shrinkWrap: true, // Membatasi ukuran GridView sesuai konten
        physics:
            const NeverScrollableScrollPhysics(), // Menonaktifkan scroll di GridView
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16, // Jarak antar kolom
          mainAxisSpacing: 16, // Jarak antar baris
          childAspectRatio: 1.0, // Rasio aspek item (dapat disesuaikan)
        ),
        itemBuilder: (context, index) {
          return _buildItemCard(items[index]);
        },
      );
    } else {
      // Tampilan List untuk layar kecil
      return ListView.builder(
        // Karena diletakkan di dalam SingleChildScrollView, kita harus:
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
            ), // Padding antar item List
            child: _buildItemCard(items[index]),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    const bgColor = Color(0xFFF4F4F5);

    return Scaffold(
      backgroundColor: bgColor,
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/aerion-logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 1.0,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'HRES',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF364153),
                                    fontFamily: 'Michroma',
                                  ),
                                ),
                                Text(
                                  'Super App',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Select Cluster Group',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF364153),
                        fontFamily: 'GeistSemiBold',
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildResponsiveList(context, state.items),
                  ],
                ),
              ),
            ),
    );
  }
}
