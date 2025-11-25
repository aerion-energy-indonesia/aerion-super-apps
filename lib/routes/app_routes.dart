/// Class berisi nama-nama path untuk navigasi.
///
/// Praktik terbaik: Gunakan kebab-case (kata dipisahkan dengan hyphen)
/// untuk konsistensi pada semua string path.
class AppRoutes {
  // --- AUTH ROUTES (Root Navigator) ---
  static const String root = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  // --- SHELL ROUTES (Bottom Navigation Bar) ---
  // Ini adalah rute utama di BottomNavigationBar.
  static const String cluster = '/cluster'; // Tab 1
  static const String sites = '/sites'; // Tab 2
  static const String dashboard =
      '/dashboard'; // Tab 3 (Biasanya berisi Profile/Settings)
  static const String alert = '/alert'; // Tab 4

  // --- DASHBOARD / PROFILE SUB-ROUTES ---
  // Rute di bawah Dashboard/Profile yang mungkin tidak memiliki Bottom Bar.
  static const String profile = '/profile';

  // --- GLOBAL SETTINGS ROUTES (Root Navigator) ---
  // Rute pengaturan yang menutupi seluruh layar, tidak terikat ShellRoute.
  static const String settings = '/settings';

  // Sub-routes di bawah /settings (untuk navigasi bersarang)
  static const String aboutUs = 'about-us';
  static const String changePassword = 'change-password';
  static const String changeProfile = 'change-profile';
  static const String languageSettings = 'language-settings';
  static const String help = 'help';

  // Contoh rute detail/aksi
  static const String editDeviceName =
      'edit-device-name'; // Sub-route, misalnya, dari /sites

  static const String data = '/data';
  static const String analysis = '/analysis';
  static const String activity = '/activity';
}
