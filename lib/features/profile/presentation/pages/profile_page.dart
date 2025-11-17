import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:aerion_dashboard/features/auth/presentation/providers/auth_notifier.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Listener untuk menangani logout dan error
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      final notifier = context.read<AuthNotifier>();
      final state = notifier.state;

      // Cek jika terjadi error
      if (state.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
          notifier.resetError();
        });
      }

      // Cek jika user berhasil Sign Out (user == null dan tidak sedang loading)
      // Kita asumsikan setelah logout, kita redirect ke halaman login ('/login')
      if (state.user == null && !state.isSigningOut && !state.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
      }
    };

    // Tambahkan listener
    context.read<AuthNotifier>().addListener(_listener);
  }

  @override
  void dispose() {
    context.read<AuthNotifier>().removeListener(_listener);
    super.dispose();
  }

  void _signOut() {
    context.read<AuthNotifier>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthNotifier>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Bagian Header Profil ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.user?.email ??
                              'User ID: ${state.user?.uid ?? "Loading..."}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user?.uid ?? 'Tidak ada UID',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Bagian Pengaturan dan Logout ---
                  const Text(
                    'Akun dan Pengaturan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ListTile Aksi (Contoh)
                  _buildProfileTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Ganti Kata Sandi',
                    onTap: () {
                      // Arahkan ke halaman ganti password (opsional)
                    },
                  ),
                  _buildProfileTile(
                    icon: Icons.language,
                    title: 'Bahasa',
                    onTap: () {
                      // Arahkan ke halaman pengaturan bahasa
                    },
                  ),

                  const SizedBox(height: 24),

                  // Tombol Logout
                  ElevatedButton.icon(
                    onPressed: state.isSigningOut ? null : _signOut,
                    icon: state.isSigningOut
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      state.isSigningOut ? 'Logging out...' : 'Logout',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
