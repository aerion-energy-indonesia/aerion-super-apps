import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository repository;

  SignOutUsecase(this.repository);

  Future<Either<AuthFailure, Unit>> call() async {
    final result = await repository.signOut();
    // PENTING: Jika sign out berhasil, hapus data cache.
    result.fold(
      // Jika gagal (AuthFailure), tidak lakukan apa-apa
      (failure) => null,
      // Jika sukses (Unit), hapus data cache
      (_) async {
        await repository.clearCachedAuthData();
      },
    );
    return result;
  }
}
