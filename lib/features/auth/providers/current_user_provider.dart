import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart' as auth;
import 'package:porkapp/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider para el usuario actual
final currentUserProvider = Provider<User?>((ref) {
  // Escuchar cambios en el estado de autenticación
  final authState = ref.watch(auth.authStateProvider);

  // Si no está autenticado, retornar null
  if (authState != auth.AuthState.authenticated) {
    return null;
  }

  // Retornar el usuario actual de Supabase
  return supabase.auth.currentUser;
});
