import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/user_role_provider.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

/// Authentication states for the app
enum AuthState { initial, unauthenticated, authenticated }

/// Provider for the current auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(_getInitialState()) {
    _initialize();
  }

  // Obtener el estado inicial de forma sincrónica para evitar parpadeos
  static AuthState _getInitialState() {
    final currentSession = supabase.auth.currentSession;
    final currentUser = supabase.auth.currentUser;

    if (currentSession != null && currentUser != null) {
      print('Initial state: authenticated (existing session)');
      return AuthState.authenticated;
    } else {
      print('Initial state: unauthenticated (no session)');
      return AuthState.unauthenticated;
    }
  }

  StreamSubscription? _authSubscription;

  Future<void> _initialize() async {
    print('Initializing AuthStateNotifier');

    // Listen to auth state changes
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      print('Auth state changed: ${event.event}');
      print('Session: ${event.session?.user.email}');

      // Solo actualizar el estado si el evento es signOut o signInWithPassword
      switch (event.event) {
        case AuthChangeEvent.signedOut:
          print('User signed out');
          state = AuthState.unauthenticated;
          break;
        case AuthChangeEvent.signedIn:
          // Solo autenticar si fue por signInWithPassword
          if (event.session != null) {
            print('User signed in with password');
            // Actualizar el estado inmediatamente para evitar parpadeos
            state = AuthState.authenticated;
          }
          break;
        case AuthChangeEvent.tokenRefreshed:
          // Mantener el estado autenticado cuando se refresca el token
          if (event.session != null) {
            print('Token refreshed');
            state = AuthState.authenticated;
          }
          break;
        case AuthChangeEvent.initialSession:
          // Manejar sesión inicial de forma explícita
          if (event.session != null) {
            print('Initial session detected');
            state = AuthState.authenticated;
          }
          break;
        default:
          // Ignorar otros eventos
          print('Ignoring auth event: ${event.event}');
          break;
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    print('AuthStateNotifier: Starting sign in...');
    await supabase.auth.signInWithPassword(email: email, password: password);
    // El listener se encargará de actualizar el estado
    // Invalidate the user role provider to force a refetch
    ref.invalidate(userRoleProvider);
    print('AuthStateNotifier: Sign in completed');
  }

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    // Invalidate the user role provider to reset it
    ref.invalidate(userRoleProvider);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
