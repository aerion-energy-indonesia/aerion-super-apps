import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthEntity> signInWithEmailAndPassword(String email, String password);
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
      throw e;
    } catch (e) {
      // Melempar exception umum
      throw Exception('Failed to sign in: $e');
    }
  }
}
