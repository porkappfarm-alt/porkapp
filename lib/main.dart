import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:porkapp/router.dart';
import 'package:porkapp/shared/design/app_theme.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:porkapp/features/biometrics/data/local/biometric_sync_service.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _initAuthListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links when app is already started
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    // Check if app was opened by a deep link
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }
  }

  void _initAuthListener() {
    // Listen to auth state changes from Supabase
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        print('Auth event: ${data.event}');

        // When password recovery event is detected, navigate to recovery screen
        if (data.event == AuthChangeEvent.passwordRecovery) {
          print(
              'Password recovery event detected, navigating to /password-recovery');
          // Add a small delay to ensure the router is ready
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              final router = ref.read(routerProvider);
              router.go('/password-recovery');
            }
          });
        }
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    print('Deep link received: $uri');
    // Supabase will handle the token automatically and trigger auth state change
    // We just log it here for debugging
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'PorkApp',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
    );
  }
}
