import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/auth/presentation/login_view.dart';
import 'package:porkapp/features/auth/screens/blocked_screen.dart';
import 'package:porkapp/features/auth/screens/pending_screen.dart';
import 'package:porkapp/features/home/screens/home_screen.dart';

// Debug helper
void _printRouteInfo(String message) {
  print('Router: $message');
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      _printRouteInfo('Current auth state: $authState');
      _printRouteInfo('Current path: ${state.path}');
      
      // Always allow access to login page when unauthenticated
      if (authState == AuthState.unauthenticated && state.path == '/login') {
        _printRouteInfo('Allowing access to login page');
        return null;
      }

      // Handle different auth states
      switch (authState) {
        case AuthState.initial:
          _printRouteInfo('Initial state - no redirect');
          return null;
          
        case AuthState.unauthenticated:
          _printRouteInfo('User is unauthenticated - redirecting to login');
          return '/login';
          
        case AuthState.profilePending:
          _printRouteInfo('Profile pending approval - redirecting to pending page');
          return '/pending';
          
        case AuthState.profileBlocked:
          _printRouteInfo('Profile blocked - redirecting to blocked page');
          return '/blocked';
          
        case AuthState.profileApproved:
          if (state.path == '/login') {
            _printRouteInfo('User is authenticated - redirecting to home');
            return '/';
          }
          _printRouteInfo('User is on a valid page');
          return null;
          
        default:
          _printRouteInfo('Unhandled state - no redirect');
          return null;
      }
    },
    routes: [
      // Auth screen
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      // Pending approval screen
      GoRoute(
        path: '/pending',
        builder: (context, state) => const PendingScreen(),
      ),
      // Blocked screen
      GoRoute(
        path: '/blocked',
        builder: (context, state) => const BlockedScreen(),
      ),
      // Home screen (requires approved profile)
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});