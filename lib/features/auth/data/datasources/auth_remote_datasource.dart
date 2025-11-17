import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthEntity> signInWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<AuthEntity?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<AuthEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User is null after sign in.',
        );
      }

      // Mengubah objek Firebase User menjadi AuthEntity
      return AuthEntity(uid: user.uid, email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      // Melempar kembali FirebaseAuthException untuk di-handle di lapisan atas
      rethrow;
    } catch (e) {
      // Melempar exception umum
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Melempar kembali FirebaseAuthException untuk di-handle di lapisan atas
      rethrow;
    } catch (e) {
      // Melempar exception umum
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<AuthEntity?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return AuthEntity(uid: user.uid, email: user.email ?? '');
    } else {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
