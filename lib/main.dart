import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
// --- Tambahan untuk Firebase Auth ---
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// --- Import Komponen Auth Clean Architecture ---
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/presentation/providers/auth_notifier.dart';
// --- Komponen Lain ---
import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- Dependency Injection (DI) untuk AuthNotifier ---
  // Kita inisialisasi semua layer Auth di sini:
  final firebaseAuthInstance = FirebaseAuth.instance;

  final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuthInstance);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final signInUsecase = SignInUsecase(authRepository);
  // --- End DI Auth ---

  runApp(
    // Menggunakan MultiProvider untuk menyediakan semua ChangeNotifier
    MultiProvider(
      providers: [
        // 1. Provider untuk AppState (yang sudah ada)
        ChangeNotifierProvider(
          create: (_) => AppState(OnboardingRepositoryImpl()),
        ),
        // 2. Provider untuk AuthNotifier (Firebase Auth)
        ChangeNotifierProvider(create: (_) => AuthNotifier(signInUsecase)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aerion Dashboard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en'), Locale('id')],
      localizationsDelegates: const [AppLocalizations.delegate],
      routerConfig: AppRouter.router,
    );
  }
}
