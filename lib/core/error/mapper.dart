import 'dart:async';

import 'exceptions.dart';
import 'failures.dart';

/// Maps low-level Exceptions into domain Failures.
Failure mapExceptionToFailure(Exception exception) {
  if (exception is ServerException) {
    return ServerFailure(exception.message ?? 'Server failure');
  }

  if (exception is CacheException) {
    return CacheFailure(exception.message ?? 'Cache failure');
  }

  if (exception is TimeoutException) {
    return ServerFailure('Request timed out');
  }

  // Fallback to a generic server failure with exception message
  final msg = exception.toString();
  return ServerFailure(msg.isNotEmpty ? msg : 'Unknown error');
}
