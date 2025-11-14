import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(DashboardRepositoryImpl()),
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
