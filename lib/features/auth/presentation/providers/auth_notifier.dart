import 'package:aerion_dashboard/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter/material.dart';
import 'package:aerion_dashboard/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:aerion_dashboard/features/auth/domain/entities/auth_entity.dart';
import 'package:aerion_dashboard/features/auth/domain/usecases/sign_in_usecase.dart';

// Definisi State yang akan di-expose
class AuthState {
  final bool isLoading;
  final AuthEntity? user;
  final String? error;
  final bool isSigningOut;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isSigningOut = false,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthEntity? user,
    String? error,
    bool clearError = false,
    bool? isSigningOut,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : error ?? this.error,
      isSigningOut: isSigningOut ?? this.isSigningOut,
    );
  }
}

// AuthNotifier menggunakan ChangeNotifier untuk State Management
class AuthNotifier extends ChangeNotifier {
  final SignInUsecase signInUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SignOutUsecase signOutUsecase;

  AuthNotifier(
    this.signInUsecase,
    this.resetPasswordUsecase,
    this.signOutUsecase,
  );

  // State Internal
  AuthState _state = AuthState();
  AuthState get state => _state; // Getter untuk mengakses state

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
