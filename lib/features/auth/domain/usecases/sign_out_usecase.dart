import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository repository;

  SignOutUsecase(this.repository);

  Future<Either<AuthFailure, Unit>> call() async {
    return await repository.signOut();
  }
}
