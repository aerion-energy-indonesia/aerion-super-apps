/// Abstract network info to check connectivity before remote calls
abstract class NetworkInfo {
  /// Returns true when device has active internet connection
  Future<bool> get isConnected;
}
