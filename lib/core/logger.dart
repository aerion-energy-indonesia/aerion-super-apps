import 'package:flutter/foundation.dart';

/// Simple logger wrapper to centralize logging behavior
void appLog(String message, {String? tag}) {
  final prefix = tag == null ? '[App]' : '[App][$tag]';
  if (kDebugMode) {
    // use debugPrint to avoid truncation on long messages
    debugPrint('$prefix $message');
  }
}
