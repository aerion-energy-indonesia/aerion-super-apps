import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// Asumsi: Anda memiliki file failure/exception yang sesuai,
// namun di sini kita menggunakan String untuk menyederhanakan error handling.
typedef AuthFailure = String;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AuthFailure, AuthEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userEntity = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(userEntity);
    } on FirebaseAuthException catch (e) {
      // Mengubah kode error Firebase menjadi pesan yang user-friendly
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An unknown error occurred during login.';
      }
      return Left(errorMessage);
    } on Exception catch (_) {
      return const Left('Could not connect to the server.');
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An unknown error occurred during password reset.';
      }
      return Left(errorMessage);
    } on Exception catch (_) {
      return const Left('Could not connect to the server.');
    }
  }
}
