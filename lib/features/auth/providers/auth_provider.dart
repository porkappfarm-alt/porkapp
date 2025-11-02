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

  AuthStateNotifier(this.ref) : super(AuthState.initial) {
    _initialize();
  }

  StreamSubscription? _authSubscription;

  Future<void> _initialize() async {
    print('Initializing AuthStateNotifier');

    // Siempre iniciar como no autenticado
    state = AuthState.unauthenticated;

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
            state = AuthState.authenticated;
          }
          break;
        default:
          // Ignorar otros eventos
          break;
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
    // Invalidate the user role provider to force a refetch
    ref.invalidate(userRoleProvider);
  }

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
