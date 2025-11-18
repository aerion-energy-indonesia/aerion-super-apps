import 'package:dartz/dartz.dart';
import '../entities/auth_entity.dart';

typedef AuthFailure = String;

abstract class AuthRepository {
  Future<Either<AuthFailure, AuthEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<AuthFailure, AuthEntity?>> getCurrentUser();

  Future<Either<AuthFailure, Unit>> resetPassword(String email);

  Future<Either<AuthFailure, Unit>> signOut();

  Future<Either<AuthFailure, Unit>> cacheAuthData(AuthEntity authData);

  Future<Either<AuthFailure, AuthEntity?>> getCachedAuthData();

  Future<Either<AuthFailure, Unit>> clearCachedAuthData();
}
