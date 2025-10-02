import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/supabase/supabase.dart';

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

    // Set initial state based on current session
    final session = supabase.auth.currentSession;
    state = session != null
        ? AuthState.authenticated
        : AuthState.unauthenticated;

    // Listen to auth state changes
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      print('Auth state changed: ${event.event}');
      print('Session: ${event.session?.user.email}');

      if (event.session == null) {
        print('Session is null - user is unauthenticated');
        state = AuthState.unauthenticated;
      } else {
        print('Session is valid - user is authenticated');
        state = AuthState.authenticated;
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
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
