import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aerion_dashboard/features/auth/domain/entities/auth_entity.dart';
import 'package:aerion_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:aerion_dashboard/features/auth/data/datasources/auth_remote_datasource.dart';

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

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } on Exception catch (_) {
      return const Left('Could not connect to the server.');
    }
  }

  @override
  Future<Either<AuthFailure, AuthEntity>> getCurrentUser() async {
    try {
      final userEntity = await remoteDataSource.getCurrentUser();
      if (userEntity == null) {
        return const Left('Could not retrieve current user.');
      }
      return Right(userEntity);
    } on Exception catch (_) {
      return const Left('Could not retrieve current user.');
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> cacheAuthData(AuthEntity authData) async {
    // Implementasi penyimpanan data auth secara lokal (misalnya menggunakan SharedPreferences)
    try {
      // Contoh implementasi (ganti dengan logika penyimpanan yang sesuai)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', authData.uid);
      await prefs.setString('email', authData.email);
      return const Right(unit);
    } on Exception catch (_) {
      return const Left('Failed to cache auth data.');
    }
  }

  @override
  Future<Either<AuthFailure, AuthEntity?>> getCachedAuthData() async {
    // Implementasi pengambilan data auth dari penyimpanan lokal
    try {
      // Contoh implementasi (ganti dengan logika pengambilan yang sesuai)
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      final email = prefs.getString('email');
      if (uid != null && email != null) {
        return Right(AuthEntity(uid: uid, email: email));
      } else {
        return Right(null); // Tidak ada data yang di-cache
      }
    } on Exception catch (_) {
      return const Left('Failed to retrieve cached auth data.');
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> clearCachedAuthData() async {
    // Implementasi penghapusan data auth dari penyimpanan lokal
    try {
      // Contoh implementasi (ganti dengan logika penghapusan yang sesuai)
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      await prefs.remove('email');
      return const Right(unit);
    } on Exception catch (_) {
      return const Left('Failed to clear cached auth data.');
    }
  }
}
