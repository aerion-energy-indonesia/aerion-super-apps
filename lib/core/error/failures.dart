/// Failure classes returned by domain layer to the presentation layer
abstract class Failure {
  final String message;
  const Failure([this.message = 'An unknown error occurred']);
  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No network connection']);
}

class Unit {
  const Unit();
}

const unit = Unit();

class Either<L, R> {
  final L? _left;
  final R? _right;
  const Either.left(this._left) : _right = null;
  const Either.right(this._right) : _left = null;
}

extension EitherExtension<L, R> on Either<L, R> {
  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left {
    if (_left == null) {
      throw StateError('No left value');
    }
    return _left as L;
  }

  R get right {
    if (_right == null) {
      throw StateError('No right value');
    }
    return _right as R;
  }
}
