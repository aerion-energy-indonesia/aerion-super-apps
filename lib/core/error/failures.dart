/// Failure classes returned by domain layer to the presentation layer
abstract class Failure {
  final String message;
  const Failure([this.message = 'An unknown error occurred']);
  @override
  String toString() => runtimeType.toString() + ': ' + message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No network connection'])
    : super(message);
}
