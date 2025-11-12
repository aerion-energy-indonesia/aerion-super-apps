import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
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
    return MaterialApp(
      title: 'Aerion Dashboard',
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}
