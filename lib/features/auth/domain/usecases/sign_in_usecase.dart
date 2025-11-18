import 'package:dartz/dartz.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;

  SignInUsecase(this.repository);

  Future<Either<AuthFailure, AuthEntity>> call(
    String email,
    String password,
  ) async {
    final result = await repository.signInWithEmailAndPassword(email, password);

    // PENTING: Jika login berhasil, simpan data ke cache.
    result.fold(
      // Jika gagal (AuthFailure), tidak lakukan apa-apa
      (failure) => null,
      // Jika sukses (AuthEntity), simpan data ke cache
      (authData) async {
        await repository.cacheAuthData(authData);
      },
    );

    return result;
  }
}
