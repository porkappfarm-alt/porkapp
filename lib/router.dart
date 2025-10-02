import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/auth/presentation/login_view.dart';
import 'package:porkapp/features/dashboard/screens/dashboard_screen.dart';
import 'package:porkapp/features/corrals/presentation/corrals_view.dart';
import 'package:porkapp/features/batches/presentation/batches_view.dart';
import 'package:porkapp/features/animals/presentation/animals_view.dart';
import 'package:porkapp/features/biometrics/presentation/biometrics_view.dart';

// Debug helper
void _printRouteInfo(String message) {
  print('Router: $message');
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      _printRouteInfo('Current auth state: $authState');
      _printRouteInfo('Current path: ${state.uri.path}');
      _printRouteInfo('Full URI: ${state.uri}');

      final goingToLogin = state.uri.path == '/login';

      // Handle authentication states
      switch (authState) {
        case AuthState.initial:
          // Siempre redirigir a login en el estado inicial
          return '/login';
        case AuthState.unauthenticated:
          // Si no está en login, redirigir a login
          return goingToLogin ? null : '/login';
        case AuthState.authenticated:
          // Si está autenticado y va a login, redirigir a dashboard
          if (goingToLogin) return '/dashboard';
          // Si está en la ruta raíz, redirigir a dashboard
          if (state.uri.path == '/') return '/dashboard';
          return null;
      }
    },
    routes: [
      // Auth screen
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      // Main shell route for authenticated screens
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => child,
        routes: [
          // Dashboard screen
          // Dashboard route
          GoRoute(
            path: '/dashboard',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const DashboardScreen(),
          ),
          // Root route - redirects to dashboard
          GoRoute(
            path: '/',
            parentNavigatorKey: _shellNavigatorKey,
            redirect: (_, __) => '/dashboard',
          ),
          // Corrals screen
          GoRoute(
            path: '/corrals',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const CorralsView(),
          ),
          // Lotes routes
          GoRoute(
            path: '/batches',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const BatchesView(),
            routes: [
              // Animales en lote route
              GoRoute(
                path: ':batchId',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (context, state) {
                  final batchId = state.pathParameters['batchId'] ?? '';
                  final batchName = 'Lote $batchId';
                  return AnimalsView(batchId: batchId, batchName: batchName);
                },
              ),
            ],
          ),
          // Biometrics screen
          GoRoute(
            path: '/biometrics',
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const BiometricsView(),
          ),
        ],
      ),
    ],
  );
});
