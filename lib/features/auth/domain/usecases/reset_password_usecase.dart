import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase(this.repository);

  Future<Either<AuthFailure, Unit>> call(String email) async {
    // Di sini Anda bisa menambahkan validasi domain tambahan jika diperlukan,
    // sebelum memanggil repository.

    return await repository.resetPassword(email);
  }
}
