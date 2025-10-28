import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/router.dart';
import 'package:porkapp/shared/design/app_theme.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:porkapp/features/biometrics/data/local/biometric_sync_service.dart';
import 'package:porkapp/features/biometrics/data/biometrics_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: .env file not found');
  }

  // Initialize Supabase
  await initializeSupabase();

  // Initialize Providers
  final container = ProviderContainer();

  // Initialize BiometricSyncService
  try {
    final syncService = container.read(biometricSyncServiceProvider);
    await syncService.initialize();
  } catch (e) {
    print('Error initializing BiometricSyncService: $e');
  } finally {
    container.dispose();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'PorkApp',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
