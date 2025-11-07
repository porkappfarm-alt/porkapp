import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          // Los providers ya fueron invalidados en signOut()
          break;
        case AuthChangeEvent.signedIn:
          // Solo autenticar si fue por signInWithPassword
          if (event.session != null) {
            print('User signed in with password');
            // Actualizar el estado inmediatamente para evitar parpadeos
            state = AuthState.authenticated;
            // Los providers ya fueron invalidados en signIn()
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
    // Los providers se reiniciarán automáticamente al cambiar el estado de auth
    print('AuthStateNotifier: Sign in completed');
  }

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    print('AuthStateNotifier: Starting sign out...');
    print('Current state before signOut: $state');

    print('AuthStateNotifier: Calling supabase.auth.signOut()...');
    await supabase.auth.signOut();

    // Forzar actualización del estado
    print('AuthStateNotifier: Forcing state update to unauthenticated');
    state = AuthState.unauthenticated;

    // El listener también actualizará el estado
    // Los providers se reiniciarán automáticamente al cambiar el estado de auth
    print('AuthStateNotifier: Sign out completed');
    print('Current state after signOut: $state');
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
