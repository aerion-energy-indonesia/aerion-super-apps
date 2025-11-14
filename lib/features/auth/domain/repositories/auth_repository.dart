import 'package:dartz/dartz.dart';
import '../entities/auth_entity.dart';

typedef AuthFailure = String;

abstract class AuthRepository {
  Future<Either<AuthFailure, AuthEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
}
