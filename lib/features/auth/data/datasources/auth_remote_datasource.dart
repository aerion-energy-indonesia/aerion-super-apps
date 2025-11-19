import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthEntity> signInWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<AuthEntity?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

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

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User is null after sign in.',
        );
      }

      final String uid = user.uid;
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid) // Menggunakan UID dari Auth sebagai Document ID
          .get();

      if (!userDoc.exists) {
        // Penting: Tangani kasus jika dokumen pengguna di Firestore belum ada
        // (misalnya, jika registrasi belum selesai sepenuhnya)
        throw Exception(
          "Data profil pengguna tidak ditemukan di Firestore (UID: $uid).",
        );
      }

      // 3. GABUNGKAN DATA
      final firestoreData = userDoc.data() as Map<String, dynamic>;

      // Mengubah objek Firebase User menjadi AuthEntity
      return AuthEntity(
        uid: user.uid,
        email: user.email ?? '',
        username: firestoreData['username'] as String?,
        role: firestoreData['role'] as String?,
      );
    } on FirebaseAuthException catch (e) {
      // Melempar kembali FirebaseAuthException untuk di-handle di lapisan atas
      throw Exception('FirebaseAuthException: ${e.message}');
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
      throw Exception('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Melempar exception umum
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<AuthEntity?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }

      final String uid = user.uid;
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      final firestoreData = userDoc.data() as Map<String, dynamic>;

      return AuthEntity(
        uid: user.uid,
        email: user.email ?? '',
        username: firestoreData['username'] as String?,
        role: firestoreData['role'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
