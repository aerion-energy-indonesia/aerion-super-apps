import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // load items when widget appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadItems();
    });
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
                            'assets/images/icons/hres.png',
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

                    ...state.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 0.1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              print('Item ${item.subtitle} diklik');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      item.logoAsset,
                                      fit: BoxFit.contain,
                                    ),
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
                                      // Font bisa diubah jika Michroma adalah font yang tepat
                                      // fontFamily: 'Michroma',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
