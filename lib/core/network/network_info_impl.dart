import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_info.dart';

/// Concrete NetworkInfo implementation using connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  /// Returns true if device has any non-none connectivity result.
  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } on Exception {
      // On error assume no connection
      return false;
    }
  }

  /// Optional: expose a stream for connectivity changes.
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((results) => results.first);
}
