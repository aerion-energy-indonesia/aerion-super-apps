import 'package:dartz/dartz.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetCachedAuthDataUsecase {
  final AuthRepository repository;

  GetCachedAuthDataUsecase(this.repository);

  // Use Case ini memanggil method baru di Repository untuk mendapatkan
  // AuthEntity dari penyimpanan lokal (cache).
  Future<Either<AuthFailure, AuthEntity?>> call() async {
    return await repository.getCachedAuthData();
  }
}
