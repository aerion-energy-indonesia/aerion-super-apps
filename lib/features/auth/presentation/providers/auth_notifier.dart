import 'package:aerion_dashboard/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter/material.dart';
import 'package:aerion_dashboard/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:aerion_dashboard/features/auth/domain/entities/auth_entity.dart';
import 'package:aerion_dashboard/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:aerion_dashboard/features/auth/domain/usecases/get_cached_auth_data_usecase.dart';

// Definisi State yang akan di-expose
class AuthState {
  final bool isLoading;
  final AuthEntity? user;
  final String? error;
  final bool isSigningOut;
  final bool isCheckingAuth;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isSigningOut = false,
    this.isCheckingAuth = false,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthEntity? user,
    String? error,
    bool clearError = false,
    bool? isSigningOut,
    bool isCheckingAuth = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : error ?? this.error,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      isCheckingAuth: isCheckingAuth,
    );
  }
}

// AuthNotifier menggunakan ChangeNotifier untuk State Management
class AuthNotifier extends ChangeNotifier {
  final SignInUsecase signInUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SignOutUsecase signOutUsecase;
  final GetCachedAuthDataUsecase getCachedAuthDataUsecase;

  AuthNotifier(
    this.signInUsecase,
    this.resetPasswordUsecase,
    this.signOutUsecase,
    this.getCachedAuthDataUsecase,
  );

  // State Internal
  AuthState _state = AuthState();
  AuthState get state => _state; // Getter untuk mengakses state
  //  status inisialisasi
  final bool _isCheckingAuth = true;
  bool get isCheckingAuth => _isCheckingAuth;

  // Anggap Anda punya method ini untuk memuat status user dari penyimpanan
  Future<void> initializeAuth() async {
    // 1. Set Status Checking Auth (agar GoRouter bisa melihat)
    _state = _state.copyWith(isCheckingAuth: true);
    notifyListeners();

    // 2. Gunakan Use Case untuk memuat data dari cache
    final result = await getCachedAuthDataUsecase.call();

    result.fold(
      (failure) {
        // Jika gagal memuat dari cache (misal: error parsing data),
        // tetap anggap user belum login.
        _state = _state.copyWith(
          isCheckingAuth: false,
          user: null, // Pastikan user null
          error: null,
        );
      },
      (authEntity) {
        // Jika AuthEntity berhasil dimuat (berarti sudah login)
        _state = _state.copyWith(
          isCheckingAuth: false,
          user: authEntity, // User sudah login
          error: null,
        );
      },
    );
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    // 1. Set Loading State
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    final result = await signInUsecase.call(email, password);

    result.fold(
      (failure) {
        // 2. Set Failure State
        _state = _state.copyWith(isLoading: false, error: failure, user: null);
      },
      (userEntity) {
        // 3. Set Success State
        _state = _state.copyWith(
          isLoading: false,
          user: userEntity,
          error: null,
        );
      },
    );
    notifyListeners();
  }

  // Fungsi untuk mereset error setelah ditampilkan
  void resetError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  // Fungsi untuk reset password
  Future<void> resetPassword(String email) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    final result = await resetPasswordUsecase.call(email);
    result.fold(
      (failure) {
        _state = _state.copyWith(isLoading: false, error: failure);
      },
      (_) {
        _state = _state.copyWith(isLoading: false, error: null);
      },
    );
    notifyListeners();
  }

  // Fungsi untuk sign out
  Future<void> signOut() async {
    _state = _state.copyWith(isSigningOut: true, error: null);
    notifyListeners();

    final result = await signOutUsecase.call();
    result.fold(
      (failure) {
        _state = _state.copyWith(isSigningOut: false, error: failure);
      },
      (_) {
        _state = AuthState(); // Reset state setelah sign out
      },
    );
    notifyListeners();
  }
}
