import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/auth/data/auth_repository.dart';
import 'package:porkapp/features/auth/presentation/login_view.dart';
import 'package:porkapp/features/auth/presentation/views/change_password_view.dart';
import 'package:porkapp/features/auth/presentation/views/reset_password_view.dart';
import 'package:porkapp/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:porkapp/features/dashboard/presentation/views/all_alerts_view.dart';
import 'package:porkapp/features/corrals/presentation/corrals_view.dart';
import 'package:porkapp/features/batches/presentation/batches_view.dart';
import 'package:porkapp/features/batches/presentation/views/batch_detail_view.dart';
import 'package:porkapp/features/batches/presentation/views/batch_animals_view.dart';
import 'package:porkapp/features/animals/presentation/views/animal_detail_view.dart';
import 'package:porkapp/features/biometrics/presentation/views/batch_biometric_detail_view.dart';
import 'package:porkapp/features/biometrics/presentation/views/new_biometric_view.dart';
import 'package:porkapp/shared/design/bottom_nav_bar.dart';
import 'package:porkapp/features/batches/presentation/create_batch_view.dart';
import 'package:porkapp/features/admin/presentation/views/admin_view.dart';
import 'package:porkapp/features/auth/providers/user_role_provider.dart';
import 'package:porkapp/features/feeding/presentation/views/feeding_management_view.dart';
import 'package:porkapp/features/users/presentation/views/user_management_view.dart';
import 'package:porkapp/features/profile/presentation/views/profile_view.dart';

// Debug helper
void _printRouteInfo(String message) {
  print('Router: $message');
}

// Navigator keys for different navigation levels
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _corralsNavigatorKey = GlobalKey<NavigatorState>();
final _batchesNavigatorKey = GlobalKey<NavigatorState>();
final _adminNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

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
    redirect: (context, state) async {
      final userRoleAsync = ref.watch(userRoleProvider);

      // Espera a que el provider de rol esté resuelto antes de redirigir
      if (userRoleAsync.isLoading) {
        print('[router] userRoleProvider is loading...');
        return null;
      }
      final userRole = userRoleAsync.asData?.value ?? 'guest';
      print('[router] userRole: \x1B[35m$userRole\x1B[0m');

      _printRouteInfo('Current auth state: $authState');
      _printRouteInfo('Current path: ${state.uri.path}');
      _printRouteInfo('Full URI: ${state.uri}');

      final goingToLogin = state.uri.path == '/login';
      final goingToChangePassword = state.uri.path == '/change-password';
      final currentLocation = state.uri.path;

      // Handle authentication states
      switch (authState) {
        case AuthState.initial:
          return '/login';
        case AuthState.unauthenticated:
          return goingToLogin ? null : '/login';
        case AuthState.authenticated:
          // Verificar si el usuario necesita cambiar la contraseña
          try {
            final authRepo = ref.read(authRepositoryProvider);
            final needsChange = await authRepo.needsPasswordChange();

            if (needsChange && !goingToChangePassword) {
              print('[router] Usuario necesita cambiar contraseña');
              return '/change-password';
            }

            // Si está en change-password pero ya no necesita cambiar, redirigir
            if (goingToChangePassword && !needsChange) {
              return '/dashboard';
            }
          } catch (e) {
            print('[router] Error verificando needs_password_change: $e');
          }

          // Restricción por rol para /admin
          if (state.uri.path.startsWith('/admin') && userRole != 'admin') {
            print('[router] Redirigiendo a dashboard por rol: $userRole');
            return '/dashboard';
          }
          if (currentLocation == '/') {
            return '/dashboard';
          }
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

      // Ruta: /change-password
      // - Pantalla obligatoria de cambio de contraseña para nuevos usuarios
      // - Se muestra fuera del shell principal
      GoRoute(
        path: '/change-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChangePasswordView(),
      ),

      // Ruta: /reset-password
      // - Pantalla para restablecer contraseña desde email de recuperación
      // - Se muestra fuera del shell principal
      GoRoute(
        path: '/reset-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResetPasswordView(),
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
                routes: [
                  GoRoute(
                    path: 'alerts',
                    builder: (context, state) => const AllAlertsView(),
                  ),
                ],
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

          // 4. Profile Branch (siempre disponible para todos los usuarios)
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),

          // 5. Admin Branch (solo para administradores)
          StatefulShellBranch(
            navigatorKey: _adminNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin',
                builder: (context, state) => const AdminView(),
                routes: [
                  GoRoute(
                    path: 'feeding',
                    builder: (context, state) => const FeedingManagementView(),
                  ),
                  GoRoute(
                    path: 'users',
                    builder: (context, state) => const UserManagementView(),
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
