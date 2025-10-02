import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/auth/presentation/login_view.dart';
import 'package:porkapp/features/dashboard/screens/dashboard_screen.dart';
import 'package:porkapp/features/corrals/presentation/corrals_view.dart';
import 'package:porkapp/features/batches/presentation/batches_view.dart';
import 'package:porkapp/features/batches/presentation/views/batch_detail_view.dart';
import 'package:porkapp/features/biometrics/presentation/biometrics_view.dart';
import 'package:porkapp/shared/design/bottom_nav_bar.dart';

// Debug helper
void _printRouteInfo(String message) {
  print('Router: $message');
}

// Navigator keys for different navigation levels
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _corralsNavigatorKey = GlobalKey<NavigatorState>();
final _batchesNavigatorKey = GlobalKey<NavigatorState>();
final _biometricsNavigatorKey = GlobalKey<NavigatorState>();

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
      final currentLocation = state.uri.path;

      // Handle authentication states
      switch (authState) {
        case AuthState.initial:
          // Always redirect to login in initial state
          return '/login';
        case AuthState.unauthenticated:
          // Always redirect to login if unauthenticated
          return goingToLogin ? null : '/login';
        case AuthState.authenticated:
          // If at root path, redirect to dashboard
          if (currentLocation == '/') {
            return '/dashboard';
          }
          // Allow access to other routes if authenticated
          // But redirect from login to dashboard
          if (goingToLogin) {
            return '/dashboard';
          }
          return null;
      }
    },
    routes: [
      // ===== Autenticación =====
      // Ruta: /login
      // - Pantalla de inicio de sesión
      // - Se muestra fuera del shell principal
      // - Redirige a /dashboard si ya está autenticado
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginView(),
      ),

      // Main shell route with bottom navigation for authenticated screens
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 1. Dashboard Branch
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
              // Root path redirects to dashboard
              GoRoute(path: '/', redirect: (_, __) => '/dashboard'),
            ],
          ),

          // 2. Corrals Branch
          StatefulShellBranch(
            navigatorKey: _corralsNavigatorKey,
            routes: [
              GoRoute(
                path: '/corrals',
                builder: (context, state) => const CorralsView(),
              ),
            ],
          ),

          // 3. Batches Branch (includes nested animals)
          StatefulShellBranch(
            navigatorKey: _batchesNavigatorKey,
            routes: [
              GoRoute(
                path: '/batches',
                builder: (context, state) => const BatchesView(),
                routes: [
                  GoRoute(
                    // This will be displayed in full screen, above the shell
                    path: ':batchId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final batchId = state.pathParameters['batchId'] ?? '';
                      return BatchDetailView(batchId: batchId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // 4. Biometrics Branch
          StatefulShellBranch(
            navigatorKey: _biometricsNavigatorKey,
            routes: [
              GoRoute(
                path: '/biometrics',
                builder: (context, state) => const BiometricsView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
