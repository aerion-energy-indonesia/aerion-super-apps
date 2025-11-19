import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Domain
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
// Data
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
// Presentation
import '../features/auth/presentation/providers/auth_notifier.dart';

// --- Instansiasi Global GetIt ---
final serviceLocator = GetIt.instance;

/// Fungsi untuk menginisialisasi semua dependensi aplikasi.
Future<void> initDependencies() async {
  // =========================================================================
  // 0. Eksternal / Core
  // =========================================================================
  // Mendaftarkan instansi FirebaseAuth sebagai Singleton
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);

  // =========================================================================
  // 1. Feature: Auth (Autentikasi)
  // =========================================================================

  // Presentation Layer
  // Kita daftarkan AuthNotifier sebagai Factory.
  // Catatan: Provider (ChangeNotifier) biasanya didaftarkan sebagai Factory
  // atau Prototype agar setiap widget Provider.of memiliki instance baru.
  serviceLocator.registerFactory(
    () => AuthNotifier(
      serviceLocator(), // Membutuhkan SignInUsecase
      serviceLocator(), // Membutuhkan ResetPasswordUsecase
      serviceLocator(), // Membutuhkan SignOutUsecase
      serviceLocator(), // Membutuhkan GetCachedAuthDataUsecase
    ),
  );

  // Domain Layer - Use Cases
  serviceLocator.registerLazySingleton(
    () => SignInUsecase(serviceLocator()), // Membutuhkan AuthRepository
  );

  // Tambahkan registrasi untuk ResetPasswordUsecase
  serviceLocator.registerLazySingleton(
    () => ResetPasswordUsecase(serviceLocator()), // Membutuhkan AuthRepository
  );

  // Domain Layer - Repository Contracts (Interface)
  // Mendaftarkan implementasi konkret sebagai LazySingleton
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ), // Membutuhkan AuthRemoteDataSource
  );

  // Data Layer - Data Sources
  // Mendaftarkan implementasi Data Source sebagai LazySingleton
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(), // Membutuhkan FirebaseAuth
      serviceLocator(), // Membutuhkan FirebaseFirestore
    ),
  );

  // =========================================================================
  // 2. Core (Utilitas Bersama)
  // =========================================================================

  // ... Anda bisa menambahkan Core utilities seperti NetworkInfo di sini
}
