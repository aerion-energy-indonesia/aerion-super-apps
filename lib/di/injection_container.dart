import 'package:get_it/get_it.dart';
// import 'package:flutter/foundation.dart'; // Untuk unit (Right(()))

// --- MOCK IMPORT (Ganti dengan import sebenarnya) ---
// Lapisan Domain
// import '../features/auth/domain/entities/auth_entity.dart';
// import '../features/auth/domain/repositories/auth_repository.dart';
// import '../features/auth/domain/usecases/sign_in_usecase.dart';

// Lapisan Data
// import '../features/auth/data/repositories/auth_repository_impl.dart';
// Perlu Data Sources yang benar
// import '../features/auth/data/repositories/auth_repository_impl.dart' show AuthRemoteDataSource, AuthRemoteDataSourceImpl;
// Mock untuk unit (dartz) dan Failure
// import '../features/auth/data/repositories/auth_repository_impl.dart' show ServerException, Failure, ServerFailure, UnknownFailure, UserModel, unit;

// Lapisan Presentation (Provider/Bloc)
// import '../features/auth/presentation/providers/auth_provider.dart';

// --- Instansiasi Global GetIt ---
final serviceLocator = GetIt.instance;

/// Fungsi untuk menginisialisasi semua dependensi aplikasi.
Future<void> initDependencies() async {
  // =========================================================================
  // 1. Feature: Auth (Autentikasi)
  // =========================================================================

  // Presentation Layer
  // Kita mendaftarkan Provider/Bloc sebagai Factory atau LazySingleton
  // serviceLocator.registerFactory(() => AuthProvider(
  //       signInUseCase: serviceLocator(), // Membutuhkan UseCase
  // ));

  // Domain Layer - Use Cases
  // serviceLocator.registerLazySingleton(
  //   () => SignInUseCase(serviceLocator()), // Membutuhkan AuthRepository
  // );

  // Domain Layer - Repository Contracts (Interface)
  // Mendaftarkan implementasi konkret sebagai LazySingleton untuk Repository
  // serviceLocator.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: serviceLocator()), // Membutuhkan AuthRemoteDataSource
  // );

  // Data Layer - Data Sources
  // Mendaftarkan implementasi Data Source sebagai LazySingleton
  // serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(),
  // );

  // =========================================================================
  // 2. Core (Utilitas Bersama)
  // =========================================================================

  // Core Utilities (Contoh: Shared Preferences, Dio Client, dll.)
  // serviceLocator.registerLazySingleton(() => DioClient(serviceLocator()));
  // serviceLocator.registerLazySingleton(() => NetworkInfo(serviceLocator()));

  // Misalnya, mendaftarkan koneksi database jika diperlukan
  // final sharedPreferences = await SharedPreferences.getInstance();
  // serviceLocator.registerLazySingleton(() => sharedPreferences);

  // ... Tambahkan dependensi untuk fitur lain di sini (Dashboard, Settings, dll.)
}
