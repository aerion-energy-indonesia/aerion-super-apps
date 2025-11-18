import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserToken(String token);
  Future<String?> getCachedUserToken();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  // ignore: constant_identifier_names
  static const String CACHED_TOKEN = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUserToken(String token) {
    // Menyimpan token saat login berhasil
    return sharedPreferences.setString(CACHED_TOKEN, token);
  }

  @override
  Future<String?> getCachedUserToken() {
    // Memuat token saat aplikasi dimulai
    return Future.value(sharedPreferences.getString(CACHED_TOKEN));
  }

  @override
  Future<void> clearCache() {
    // Menghapus token saat logout
    return sharedPreferences.remove(CACHED_TOKEN);
  }
}
