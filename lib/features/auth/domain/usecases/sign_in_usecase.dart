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
    // Di sini Anda bisa menambahkan validasi domain tambahan jika diperlukan,
    // sebelum memanggil repository.

    return await repository.signInWithEmailAndPassword(email, password);
  }
}
