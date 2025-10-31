import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/auth/presentation/login_view.dart';
import 'package:porkapp/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:porkapp/features/corrals/presentation/corrals_view.dart';
import 'package:porkapp/features/batches/presentation/batches_view.dart';
import 'package:porkapp/features/batches/presentation/views/batch_detail_view.dart';
import 'package:porkapp/features/batches/presentation/views/batch_animals_view.dart';
import 'package:porkapp/features/animals/presentation/views/animal_detail_view.dart';
import 'package:porkapp/features/biometrics/presentation/views/batch_biometric_detail_view.dart';
import 'package:porkapp/features/biometrics/presentation/views/new_biometric_view.dart';
import 'package:porkapp/shared/design/bottom_nav_bar.dart';
import 'package:porkapp/features/batches/presentation/create_batch_view.dart';

// Debug helper
void _printRouteInfo(String message) {
  print('Router: $message');
}

// Navigator keys for different navigation levels
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _corralsNavigatorKey = GlobalKey<NavigatorState>();
final _batchesNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    errorBuilder: (context, state) {
      _printRouteInfo('Navigation error: ${state.error}');
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFF0F0),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE57373).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Color(0xFFE57373),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error de navegación',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: const Color(0xFF5D4037),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/dashboard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE57373),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Volver al Dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
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
                builder: (context, state) => const DashboardView(),
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
                    path: 'create',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CreateBatchView(),
                  ),
                  GoRoute(
                    path: 'edit/:batchId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final batchId = state.pathParameters['batchId'];
                      return CreateBatchView(batchId: batchId);
                    },
                  ),
                  GoRoute(
                    path: ':batchId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final batchId = state.pathParameters['batchId'] ?? '';
                      return BatchDetailView(batchId: batchId);
                    },
                    routes: [
                      // Rutas de biometrías del lote
                      GoRoute(
                        path: 'biometrics',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final batchId = state.pathParameters['batchId'] ?? '';
                          return BatchBiometricDetailView(batchId: batchId);
                        },
                        routes: [
                          GoRoute(
                            path: 'new',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) {
                              final batchId =
                                  state.pathParameters['batchId'] ?? '';
                              return NewBiometricView(
                                initialBatchId: batchId,
                              );
                            },
                          ),
                          GoRoute(
                            path: ':biometricId/weights',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) {
                              final batchId =
                                  state.pathParameters['batchId'] ?? '';
                              final biometricId =
                                  state.pathParameters['biometricId'] ?? '';
                              return NewBiometricView(
                                initialBatchId: batchId,
                                biometricId: biometricId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Vista de lista de animales del lote - MOVIDA FUERA DEL ANIDAMIENTO
                  GoRoute(
                    path: ':batchId/animals',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final batchId = state.pathParameters['batchId'] ?? '';
                      return BatchAnimalsView(batchId: batchId);
                    },
                    routes: [
                      // Detalle individual del animal
                      GoRoute(
                        path: ':animalId',
                        name: 'animal-detail',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final animalId =
                              state.pathParameters['animalId'] ?? '';
                          print(
                              'Building AnimalDetailView for animalId: $animalId'); // Debug log
                          return AnimalDetailView(animalId: animalId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
