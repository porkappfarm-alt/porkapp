import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/models/profile.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication states for the app
enum AuthState {
  initial,
  unauthenticated,
  authenticated,
  profileNotFound,
  profilePending,
  profileBlocked,
  profileApproved,
}

/// Provider for the current auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

/// Provider for the current user's profile
final profileProvider = StateProvider<Profile?>((ref) => null);

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  
  AuthStateNotifier(this.ref) : super(AuthState.initial) {
    _initialize();
  }

  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<Profile?>? _profileSubscription;
  
  Future<void> _initialize() async {
    print('Initializing AuthStateNotifier');
    
    // Listen to auth state changes
    _authSubscription = supabase.auth.onAuthStateChange.asyncMap((event) async {
      print('Auth state changed: ${event.event}');
      print('Session: ${event.session?.user.email}');
      
      if (event.session == null) {
        print('Session is null - user is unauthenticated');
        return AuthState.unauthenticated;
      }
      
      try {
        final profile = await _fetchProfile();
        if (profile == null) {
          // Create profile if it doesn't exist
          await _createProfile(event.session!.user);
          return AuthState.profilePending;
        }
        
        // Set up realtime subscription for profile changes
        _setupProfileSubscription();
        
        return _mapProfileToAuthState(profile);
      } catch (e) {
        return AuthState.unauthenticated;
      }
    }).listen((state) {
      if (mounted) {
        this.state = state;
      }
    });
  }

  Future<Profile?> _fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    print('Fetching profile for user: ${user.email}');
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      final profile = Profile.fromJson(response);
      print('Profile fetched successfully: ${profile.email} (${profile.status})');
      ref.read(profileProvider.notifier).state = profile;
      return profile;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<void> _createProfile(User user) async {
    await supabase.from('profiles').insert({
      'id': user.id,
      'email': user.email,
      'role': ProfileRole.user.name,
      'status': ProfileStatus.pending.name,
    });
  }

  void _setupProfileSubscription() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    _profileSubscription?.cancel();
    _profileSubscription = supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((data) => data.isNotEmpty ? Profile.fromJson(data.first) : null)
        .listen(
      (profile) {
        if (profile != null && mounted) {
          ref.read(profileProvider.notifier).state = profile;
          state = _mapProfileToAuthState(profile);
        }
      },
    );
  }

  AuthState _mapProfileToAuthState(Profile profile) {
    switch (profile.status) {
      case ProfileStatus.pending:
        return AuthState.profilePending;
      case ProfileStatus.blocked:
        return AuthState.profileBlocked;
      case ProfileStatus.approved:
        return AuthState.profileApproved;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }
}